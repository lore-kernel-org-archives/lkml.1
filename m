Return-Path: <linux-kernel-owner+w=401wt.eu-S1752862AbZEQQsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbZEQQsN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 12:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbZEQQr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 12:47:56 -0400
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:59000 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752091AbZEQQrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 12:47:55 -0400
Subject: regression in 2.6.30-rc6 -- via82xx sound very quiet
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: perex@perex.cz, Takashi Iwai <tiwai@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 17 May 2009 17:47:54 +0100
Message-Id: <1242578874.2748.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the current git 2.6.30-rc6 the sound from my motherboard has become
extremely quiet, I have to turn my speakers up all the way to hear
anything at all.
I'm not too sure when the problem first started but I've just tested
2.6.30-rc4 and it works correctly.  

lspci -v gives

00:11.5 Multimedia audio controller: VIA Technologies, Inc.
VT8233/A/8235/8237 AC97 Audio Controller (rev 60)
Subsystem: ABIT Computer Corp. Device 1415
Flags: medium devsel, IRQ 22
I/O ports at d800 [size=256]
Capabilities: [c0] Power Management version 2
Kernel driver in use: VIA 82xx Audio
Kernel modules: snd-via82xx

I don't see much in the log :- 

	kernel: VIA 82xx Audio 0000:00:11.5: PCI INT C -> GSI 22 (level, low) -> IRQ 22

but sometimes I get these messages
----
pulseaudio[2638]: module-alsa-sink.c: ALSA woke us up to write new data
to the device, but there was actually nothing to write! Most likely this
is an ALSA driver bug. Please report this issue to the PulseAudio
developers.
----

Any suggestions as to what's gone wrong or should I try a git bisect?

regards
Richard



