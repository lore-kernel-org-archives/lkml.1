Return-Path: <linux-kernel-owner+w=401wt.eu-S1751594AbXCDMYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594AbXCDMYh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 07:24:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbXCDMYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 07:24:36 -0500
Received: from vms042pub.verizon.net ([206.46.252.42]:64129 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbXCDMYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 07:24:36 -0500
Date: Sun, 04 Mar 2007 07:24:33 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu
 scheduler
In-reply-to: <200703042247.44196.kernel@kolivas.org>
To: linux-kernel@vger.kernel.org
Cc: Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>
Message-id: <200703040724.34321.gene.heskett@gmail.com>
Organization: very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200703041800.53360.kernel@kolivas.org>
 <200703040608.53336.gene.heskett@gmail.com>
 <200703042247.44196.kernel@kolivas.org>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 March 2007, Con Kolivas wrote:
>On Sunday 04 March 2007 22:08, Gene Heskett wrote:
>> On Sunday 04 March 2007, Con Kolivas wrote:
>> >This message is to announce the first general public release of the
>> > "Rotating Staircase DeadLine" cpu scheduler.
>>
>> I assume to test this, we select the deadline scheduler?
>
>No, only the "deadline" in the name is shared. This is a cpu process
> scheduler whereas the deadline scheduler you're thinking of is an I/O
> scheduler. To test this you just patch it in and it replaces the
> current mainline cpu scheduler (the same way the staircase cpu
> scheduler in -ck replaces it).

Oh, then I tried to put the -ck1 patch on top of that, and blew the tree 
up.  I'd built it the first time with the deadline scheduler as the 
default while I was waiting on your reply.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
