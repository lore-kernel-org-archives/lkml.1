Return-Path: <linux-kernel-owner+w=401wt.eu-S1758519AbYGPSsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758519AbYGPSsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 14:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbYGPSsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 14:48:10 -0400
Received: from cable-85.28.84.48.coditel.net ([85.28.84.48]:42514 "EHLO
	ibiza.bxl.tuxicoman.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbYGPSsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 14:48:09 -0400
Date: Wed, 16 Jul 2008 20:45:52 +0200
From: Guy Martin <gmsoft@tuxicoman.be>
To: linux-kernel@vger.kernel.org
Subject: 64bit kernel not booting with CONFIG_PRINTK_TIME=y
Message-ID: <20080716204552.56270e7c@tuxicoman.be>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi all,


I've been trying several times to boot a 64bit kernel with
CONFIG_PRINTK_TIME=y and each time it failed.

This is the output of my L2000 when trying to do so :

Information: No console specified on kernel command line. This is
normal. PALO will choose the console currently used by firmware
(serial). Command line for kernel: 'root=/dev/md1 console=ttyS0
palo_kernel=2/vmlinux' Selected kernel: /vmlinux from partition 2
ELF64 executable
Entry 00100000 first 00100000 n 2
Segment 0 load 00100000 size 4997120 mediaptr 0x1000
Segment 1 load 00634000 size 640576 mediaptr 0x4c5000
Branching to kernel entry point 0x00100000.  If this is the last
message you see, you may need to switch your console.  This is
a common symptom -- search the FAQ and mailing list at parisc-linux.org


************* SYSTEM ALERT **************
SYSTEM NAME: uninitialized
DATE: 07/16/2008 TIME: 17:47:39
ALERT LEVEL: 7 = reserved

REASON FOR ALERT
SOURCE: 0 = unknown, no source stated
SOURCE DETAIL: 0 = unknown, no source stated   SOURCE ID: FF
PROBLEM DETAIL: 0 = no problem detail

LEDs:  RUN      ATTENTION     FAULT     REMOTE     POWER
       FLASH    FLASH         OFF       ON         ON
LED State: Running non-OS code.  Non-critical error detected.
Check Chassis and Console Logs for error messages.

0x0000007000FF6292 000000F0 F0000000 - type  0 = Data Field Unused
0x5800087000FF6292 00006C06 10112F27 - type 11 = Timestamp 07/16/2008
17:47:39 A: ack read of this entry - X: Disable all future alert
messages Anything else skip redisplay the log entry
->Choice:Timeout!  
*****************************************



Recompiling with CONFIG_PRINTK_TIME=n makes it works straight away.

How can this be troubleshooted ? Any idea what the problem could be ?

I'm using gcc-4.2.4 with kernel 2.6.26 but I've have had very same
results with gcc-4.1.2 and 2.6.25.


Cheers,
  Guy

-- 
Guy Martin
Gentoo Linux - HPPA port lead

