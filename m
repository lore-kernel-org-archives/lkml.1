Return-Path: <linux-kernel-owner+w=401wt.eu-S1760935AbYCSVap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760935AbYCSVap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757024AbYCSUD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:03:29 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:34614 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755163AbYCSUDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:03:24 -0400
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.2
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: Anders Eriksson <aeriksson@fastmail.fm>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc4 
In-reply-to: <200803181548.25241.bzolnier@gmail.com> 
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <200803181403.37969.bzolnier@gmail.com> <20080318133259.E71EE2DC044@tippex.mynet.homeunix.org> <200803181548.25241.bzolnier@gmail.com>
Comments: In-reply-to Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
   message dated "Tue, 18 Mar 2008 15:48:25 +0100."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Tue, 18 Mar 2008 16:10:59 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20080318151059.F1D6A2DC044@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.237.4
X-ACL-Warn: Too high rate of unknown addresses received from you
X-Scan-Result: No virus found in message 1JbdSw-0005n2-4m.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1JbdSw-0005n2-4m 2797a4f303ecb7c576d7fc0ea0b43bfb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


bzolnier@gmail.com said:
> Please add "#define DEBUG" before ide_tf_load() in ide-taskfile.c so we can
> see which SMART sub-command is causing this. 

Mar 18 16:02:13 tippex do_rw_taskfile(task->data_phase=0, tf->command=176
Mar 18 16:02:13 tippex hda: tf: feat 0xda nsect 0x00 lbal 0x00 lbam 0x4f lbah 0xc2 dev 0x00 cmd 0xb0
Mar 18 16:02:13 tippex hda: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 16:02:14 tippex do_rw_taskfile(task->data_phase=1, tf->command=176
Mar 18 16:02:14 tippex hda: tf: feat 0xd0 nsect 0x01 lbal 0x00 lbam 0x4f lbah 0xc2 dev 0x00 cmd 0xb0
Mar 18 16:02:14 tippex hda: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 16:02:14 tippex do_rw_taskfile(task->data_phase=1, tf->command=176
Mar 18 16:02:14 tippex hda: tf: feat 0xd1 nsect 0x01 lbal 0x01 lbam 0x4f lbah 0xc2 dev 0x00 cmd 0xb0
Mar 18 16:02:14 tippex hda: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 16:02:14 tippex do_rw_taskfile(task->data_phase=1, tf->command=236
Mar 18 16:02:14 tippex hda: tf: feat 0x00 nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00 dev 0x00 cmd 0xec
Mar 18 16:02:14 tippex hda: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 16:02:14 tippex do_rw_taskfile(task->data_phase=0, tf->command=176
Mar 18 16:02:14 tippex hda: tf: feat 0xd8 nsect 0x00 lbal 0x01 lbam 0x4f lbah 0xc2 dev 0x00 cmd 0xb0
Mar 18 16:02:14 tippex hda: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 16:02:14 tippex do_rw_taskfile(task->data_phase=1, tf->command=176
Mar 18 16:02:14 tippex hda: tf: feat 0xd2 nsect 0xf1 lbal 0x00 lbam 0x4f lbah 0xc2 dev 0x00 cmd 0xb0
Mar 18 16:02:14 tippex hda: hob: nsect 0x00 lbal 0x00 lbam 0x00 lbah 0x00
Mar 18 16:02:14 tippex task_in_intr: hda: stat=50




