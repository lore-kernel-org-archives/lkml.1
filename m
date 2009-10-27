Return-Path: <linux-kernel-owner+w=401wt.eu-S1752740AbZJ0EXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbZJ0EXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 00:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbZJ0EXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 00:23:50 -0400
Received: from mail.lang.hm ([64.81.33.126]:39131 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbZJ0EXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 00:23:49 -0400
Date: Mon, 26 Oct 2009 21:23:35 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: removing existing working drivers via staging
In-Reply-To: <alpine.DEB.2.00.0910151250480.22169@asgard.lang.hm>
Message-ID: <alpine.DEB.2.00.0910262119530.14994@asgard.lang.hm>
References: <alpine.DEB.2.00.0910142213590.22169@asgard.lang.hm> <200910151942.40259.bzolnier@gmail.com> <20091015174932.GA3595@suse.de> <200910152020.13080.bzolnier@gmail.com> <20091015184656.GA29858@suse.de> <alpine.DEB.2.00.0910151200100.22169@asgard.lang.hm>
 <20091015191641.GB19467@elte.hu> <alpine.DEB.2.00.0910151230560.22169@asgard.lang.hm> <4AD77C4F.5010307@s5r6.in-berlin.de> <alpine.DEB.2.00.0910151250480.22169@asgard.lang.hm>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for those who were reading this thread, the topic has come up again in the 
thread titled

[PATCH 1/4] strip: move driver to staging

where a driver is being moved to staging because it does not have a 
maintainer and the only changes to it for some time have been due to 
kernel API changes.

the maintainer of the area feels that it's too much work to allow the 
driver to remain because it must be updated when kernel APIs change.


this is exactly the 'wants to get rid of' category I mentioned being 
concerned about below.


I don't know what was decided at the kernel summit where this was 
discussed, how easy is it supposed to be to drop drivers out of the 
kernel?

David Lang

On Thu, 15 Oct 2009, david@lang.hm wrote:

> Date: Thu, 15 Oct 2009 12:57:49 -0700 (PDT)
> From: david@lang.hm
> To: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Cc: Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
>     Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
>     linux-kernel <linux-kernel@vger.kernel.org>
> Subject: Re: removing existing working drivers via staging
> 
> On Thu, 15 Oct 2009, Stefan Richter wrote:
>
>> david@lang.hm wrote:
>>> it's these users who will discover the missing driver and care about it,
>>> not the distros.
>> 
>> I think we are talking about stuff of which users will typically
>> discover that it plainly doesn't work long before it vanishes from any
>> kernel distribution, or of which there is a superior alternative already
>> available.
>
> if there's a superior alternative already available staging isn't needed 
> (like the e1000 split), but I have also seen many new systems added to the 
> kernel that the author thinks covers all the old ones, only to find out when 
> people get it in the real world that it doesn't cover all existing hardware. 
> but this is an existing problem that is already being handled.
>
>
>
> if it clearly doesn't work that is also fine with me.
>
> however, that is not the criteria that has been expressed.
>
> from earlier in this thread
>
>        - For drivers currently in the kernel tree, that the subsystem
>          maintainer, for whatever reason, feels is obsolete / broken /
>          needs major cleaning / wants to get rid of, can be submitted
>          to the staging maintainer to be moved to the drivers/staging/
>          directory.
>
> it's the 'needs major cleaning' and 'wants to get rid of' portions that 
> concern me the most.
>
> 'obsolete' can mean that there is a superior alternative available, or it 
> could mean that the hardware the driver supports has not been manufactured in 
> several years (or, depending who you ask, several weeks ;-)
>
> David Lang
>
