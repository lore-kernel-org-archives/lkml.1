Return-Path: <linux-kernel-owner+w=401wt.eu-S1757504AbYGNSdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504AbYGNSdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 14:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756281AbYGNSdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 14:33:00 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:20360 "EHLO
	viefep13-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755183AbYGNSc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 14:32:59 -0400
Message-ID: <006801c8e5df$c5a0b310$0e66970a@ds.mot.com>
From: "Aryanto Rachmad" <aryanto.rachmad@chello.at>
To: <linux-kernel@vger.kernel.org>
Subject: Kernel 2.6.26 - *pde = 00003067 <0>Kernel panic
Date: Mon, 14 Jul 2008 20:31:02 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody,

I am not sure if I could post this question in this mailing list, so please 
forgive me and tell me the appropriate mailing list. And I am not sure 
whether this is a bug or my silly mistake, so I decided not to file in the 
bug report.

I am trying to use kernel 2.6.26 on my D945GCLF Intel Atom board using 
Debian distro and I got the kernel panic as below:

[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 1596.137 MHz processor.
[    0.010000] Console: colour VGA+ 80x25
[    0.010000] console [tty0] enabled
[    0.010000] console [ttyS0] enabled
[    0.010000] BUG: unable to handle kernel paging request at ffffffa0
[    0.010000] IP: [<c0135318>] zap_other_threads+0x38/0x70
[    0.010000] *pde = 00003067 <0>Kernel panic - not syncing: Attempted to 
kill the idle task!

Could you please suggest me what to change in my .config?

I don't want to waste everybody's bandwidth, so I don't post the whole log. 
If logs would be needed, I would be glad to provide them. But please tell me 
how collect them as I am quite new to kernel debugging :(

Cheers,

Anto 

