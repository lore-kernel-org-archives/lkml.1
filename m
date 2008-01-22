Return-Path: <linux-kernel-owner+w=401wt.eu-S1757311AbYAVOe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbYAVOe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 09:34:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbYAVOeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 09:34:19 -0500
Received: from vms042pub.verizon.net ([206.46.252.42]:61689 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbYAVOeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 09:34:18 -0500
Date: Tue, 22 Jan 2008 08:34:10 -0600
From: Corey Minyard <minyard@acm.org>
Subject: Re: [PATCH] ARM: Ignore memory tags with invalid data
In-reply-to: <20080122091834.GC27399@fluff.org.uk>
To: Ben Dooks <ben@fluff.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, hvr@gnu.org,
       rmk@arm.linux.org.uk, nico@cam.org
Message-id: <4795FEE2.3090703@acm.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <20080122040556.GA24515@minyard.local>
 <20080122091834.GC27399@fluff.org.uk>
User-Agent: Icedove 1.5.0.14pre (X11/20071018)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Dooks wrote:
> On Mon, Jan 21, 2008 at 10:05:56PM -0600, Corey Minyard wrote:
>   
>> From: Corey Minyard <minyard@acm.org>
>>
>> The DNS-323 system has several bogus memory entries in the tag table,
>> and it caused the system to crash at startup.  Ignore tag entries that
>> are obviously bogus.
>>     
>
> This should have gone to the linux-arm-kernel mailing list as well,
> so that all the people interested in ARM can see it as soon as
> possible. See linux-arm-kernel@lists.arm.linux.org.uk
>   
You have to be a member to post, and I'm not a member.  I guess I'll 
join, though it seems somewhat pointless for a single patch.

> The only suggestion I could think of would to be change to having
> an check_tag_mem32() function, or put each check on its own line
> to make it easier to read what each check is doing.
>
> ie:
> 	if (meminfo.nr_banks >= NR_BANKS ||
> 	    tag->u.mem.size & ~PAGE_MASK || /* size is unaligned */
> 	    tag->u.mem.size == 0 ||	    /* no memory here */
> 	    tag->u.mem.start & ~PAGE_MASK)  /* start is unaligned */ 
> 	{
>
> (even without the comments it makes it easier to see what each test
> is.
>   
That's fine, it is easier to read.

Thanks,

-corey
