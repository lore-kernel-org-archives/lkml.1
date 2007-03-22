Return-Path: <linux-kernel-owner+w=401wt.eu-S1752642AbXCVXeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbXCVXeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 19:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbXCVXeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 19:34:19 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:38671 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbXCVXeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 19:34:19 -0400
Message-ID: <05e401c76cdb$178be430$eeeea8c0@aldipc>
From: "roland" <devzero@web.de>
To: <linux-kernel@vger.kernel.org>
Subject: Re: max_loop limit
Date: Fri, 23 Mar 2007 00:37:44 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.2869
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.2869
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

partitions on loop or device-mapper devices ?

you can use kpartx tool for this.

bryn m. reeves told me, that it's probably poissible to create udev rules 
that will automatically create partition maps when a new loop device is 
setup, which is better than adding partitioning logig into dm-loop for 
example.

example:
>kpartx -a /dev/mapper/loop0
>
># ls /dev/mapper/loop0*
>/dev/mapper/loop0  /dev/mapper/loop0p1  /dev/mapper/loop0p2
>/dev/mapper/loop0p3

i have seen a patch for loop.c doing this, though. search the archives for 
this

regards
roland





On Thu, Mar 22, 2007 at 02:33:14PM +0000, Al Viro wrote:
> Correction: current ABI is crap.  To set the thing up you need to open
> it and issue an ioctl.  Which is a bloody bad idea, for obvious reasons...

Agreed.  What would be a right way?  Global device ala ptmx/tun/tap?
New syscall?  Something else?

  OG.
-
] 

