Return-Path: <linux-kernel-owner+w=401wt.eu-S935416AbZJOT6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935416AbZJOT6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 15:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935391AbZJOT6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 15:58:49 -0400
Received: from mail.lang.hm ([64.81.33.126]:41571 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935368AbZJOT6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 15:58:49 -0400
Date: Thu, 15 Oct 2009 12:57:49 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: removing existing working drivers via staging
In-Reply-To: <4AD77C4F.5010307@s5r6.in-berlin.de>
Message-ID: <alpine.DEB.2.00.0910151250480.22169@asgard.lang.hm>
References: <alpine.DEB.2.00.0910142213590.22169@asgard.lang.hm> <200910151942.40259.bzolnier@gmail.com> <20091015174932.GA3595@suse.de> <200910152020.13080.bzolnier@gmail.com> <20091015184656.GA29858@suse.de> <alpine.DEB.2.00.0910151200100.22169@asgard.lang.hm>
 <20091015191641.GB19467@elte.hu> <alpine.DEB.2.00.0910151230560.22169@asgard.lang.hm> <4AD77C4F.5010307@s5r6.in-berlin.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009, Stefan Richter wrote:

> david@lang.hm wrote:
>> it's these users who will discover the missing driver and care about it,
>> not the distros.
>
> I think we are talking about stuff of which users will typically
> discover that it plainly doesn't work long before it vanishes from any
> kernel distribution, or of which there is a superior alternative already
> available.

if there's a superior alternative already available staging isn't needed 
(like the e1000 split), but I have also seen many new systems added to the 
kernel that the author thinks covers all the old ones, only to find out 
when people get it in the real world that it doesn't cover all existing 
hardware. but this is an existing problem that is already being handled.



if it clearly doesn't work that is also fine with me.

however, that is not the criteria that has been expressed.

from earlier in this thread

         - For drivers currently in the kernel tree, that the subsystem
           maintainer, for whatever reason, feels is obsolete / broken /
           needs major cleaning / wants to get rid of, can be submitted
           to the staging maintainer to be moved to the drivers/staging/
           directory.

it's the 'needs major cleaning' and 'wants to get rid of' portions that 
concern me the most.

'obsolete' can mean that there is a superior alternative available, or it 
could mean that the hardware the driver supports has not been manufactured 
in several years (or, depending who you ask, several weeks ;-)

David Lang
