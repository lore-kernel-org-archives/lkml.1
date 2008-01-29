Return-Path: <linux-kernel-owner+w=401wt.eu-S1759454AbYA2CUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759454AbYA2CUv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 21:20:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbYA2CUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 21:20:41 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:45765 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbYA2CUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 21:20:41 -0500
Date: Mon, 28 Jan 2008 21:20:33 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Problem with ata layer in 2.6.24
In-reply-to: <200801282051.13680.gene.heskett@gmail.com>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Mark Lord <liml@rtr.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200801282120.33442.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <fa.YoSRdik0niRWE1jgfb9yTQPim5A@ifi.uio.no>
 <479E81FE.2090604@shaw.ca> <200801282051.13680.gene.heskett@gmail.com>
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 January 2008, Gene Heskett wrote:
>On Monday 28 January 2008, Robert Hancock wrote:
>[...]
>
>>Check the /etc/modprobe.conf file, a lot of distributions use this to
>>generate the initrd. If there's references to pata_amd it'll try and
>>include it.
>
>Bingo!  Thanks Robert, I'll try it again with that line commented.  I wasn't
>aware of that connection at all.  Yup, it worked, I feel a reboot coming
>on. :)

But it didn't work, apparently commenting that line out needs to be balanced 
by adding another line telling it amd74xx is the 'hostadapter', not 
necessarily scsi.

Can this be made more universal so I don't have to edit /etc/modprobe.conf?

Thanks.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Because we don't think about future generations, they will never forget us.
		-- Henrik Tikkanen
