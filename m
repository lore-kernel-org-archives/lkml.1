Return-Path: <linux-kernel-owner+w=401wt.eu-S1759241AbZDRSwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241AbZDRSwx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 14:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757404AbZDRSw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 14:52:28 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:59947 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbZDRSw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 14:52:27 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH/RFC 0/16] m68k: Device model patches
Date: Sat, 18 Apr 2009 20:52:08 +0200
Message-Id: <1240080744-14995-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches brings Amiga hardware support better in line with to the
Linux device model:
  - Add module alias support for Zorro drivers (not all drivers can
    benefit from this yet though, as some still use zorro_find_device()
    instead of struct zorro_driver),
  - Convert the various builtin Amiga hardware to the platform driver
    framework.

[01] platform: Make platform resources input parameters const
[02] m68k: amiga - Zorro bus modalias support
[03] m68k: amiga - Zorro host bridge platform device conversion
[04] m68k: amiga - Frame buffer platform device conversion
[05] m68k: amiga - Sound platform device conversion
[06] m68k: amiga - Floppy platform device conversion
[07] m68k: amiga - A3000 SCSI platform device conversion
[08] m68k: amiga - A4000T SCSI platform device conversion
[09] m68k: amiga - Amiga Gayle IDE platform device conversion
[10] m68k: amiga - Keyboard platform device conversion
[11] m68k: amiga - Mouse platform device conversion
[12] m68k: amiga - Serial port platform device conversion
[13] m68k: amiga - Parallel port platform device conversion
[14] rtc: Add an RTC driver for the Oki MSM6242
[15] rtc: Add an RTC driver for the Ricoh RP5C01
[16] m68k: amiga - RTC platform device conversion

Due to lack of hardware (only Amiga 4000 here), I couldn't test all drivers.
Especially the SCSI drivers could use some testing feedback.
The changes to most other drivers are fairly trivial.
Note that I removed all request_mem_region() calls for subregions of the Amiga
custom chips, as the drivers now bind to the platform device.

Thanks for your review comments (and other feedback, of course)!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
