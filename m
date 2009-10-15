Return-Path: <linux-kernel-owner+w=401wt.eu-S935393AbZJOTud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935393AbZJOTud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 15:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935368AbZJOTud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 15:50:33 -0400
Received: from mail.lang.hm ([64.81.33.126]:52915 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935367AbZJOTuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 15:50:32 -0400
Date: Thu, 15 Oct 2009 12:49:40 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Greg KH <gregkh@suse.de>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: removing existing working drivers via staging
In-Reply-To: <4AD77AC3.7040905@s5r6.in-berlin.de>
Message-ID: <alpine.DEB.2.00.0910151244561.22169@asgard.lang.hm>
References: <alpine.DEB.2.00.0910142213590.22169@asgard.lang.hm> <200910151942.40259.bzolnier@gmail.com> <20091015174932.GA3595@suse.de> <200910152020.13080.bzolnier@gmail.com> <20091015184656.GA29858@suse.de> <alpine.DEB.2.00.0910151200100.22169@asgard.lang.hm>
 <4AD77AC3.7040905@s5r6.in-berlin.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009, Stefan Richter wrote:

> david@lang.hm wrote:
>> a driver in staging will be able to build, but a driver that was removed
>> after 6-9 months that a user discovered the removal of a year later when
>> they upgraded to a new distro release (say a normal ubuntu release after
>> staying on the old one for the 18 month support period) is likely to
>> need significant work to catch up with kernel changes in the meanwhile.
>
> I don't think this new mechanism is meant to be, or can ever be, a way
> to remove things that work and that users need.

the problem I have is that the criteria that I have seen voiced for why 
something would move into staging does not require that it not work. it 
just requires that it need 'cleanup' of some sort.

removing something that worked always runs a significant risk that someone 
out there 'needs' it (sometimes removing something that's broken, but 
works in some cases causes similar problems)

> Hence the timeline of 3 releases per <20091015164726.GA10125@suse.de>
> affects developers/ janitors much more than end users.

it may be that I've jumped the gun here with my concerns, and should just 
wait until something actually gets moved to staging to see what the actual 
policies are going to be in practice, but the policies as written seem to 
be very loose.

David Lang
