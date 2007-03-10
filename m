Return-Path: <linux-kernel-owner+w=401wt.eu-S1750717AbXCJVQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750717AbXCJVQi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 16:16:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750829AbXCJVQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 16:16:38 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:49384 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbXCJVQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 16:16:37 -0500
X-Originating-Ip: 74.109.98.130
Date: Sat, 10 Mar 2007 16:13:27 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Roman Zippel <zippel@linux-m68k.org>, Andrew Morton <akpm@osdl.org>
Subject: [PATCH] M68K: Delete unused header file.
Message-ID: <Pine.LNX.4.64.0703101612160.27453@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Delete the apparently unused header file arch/m68k/atari/atasound.h.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/arch/m68k/atari/atasound.h b/arch/m68k/atari/atasound.h
deleted file mode 100644
index 1362762..0000000
--- a/arch/m68k/atari/atasound.h
+++ /dev/null
@@ -1,33 +0,0 @@
-/*
- * Minor numbers for the sound driver.
- *
- * Unfortunately Creative called the codec chip of SB as a DSP. For this
- * reason the /dev/dsp is reserved for digitized audio use. There is a
- * device for true DSP processors but it will be called something else.
- * In v3.0 it's /dev/sndproc but this could be a temporary solution.
- */
-
-#define SND_NDEVS	256	/* Number of supported devices */
-#define SND_DEV_CTL	0	/* Control port /dev/mixer */
-#define SND_DEV_SEQ	1	/* Sequencer output /dev/sequencer (FM
-				   synthesizer and MIDI output) */
-#define SND_DEV_MIDIN	2	/* Raw midi access */
-#define SND_DEV_DSP	3	/* Digitized voice /dev/dsp */
-#define SND_DEV_AUDIO	4	/* Sparc compatible /dev/audio */
-#define SND_DEV_DSP16	5	/* Like /dev/dsp but 16 bits/sample */
-#define SND_DEV_STATUS	6	/* /dev/sndstat */
-/* #7 not in use now. Was in 2.4. Free for use after v3.0. */
-#define SND_DEV_SEQ2	8	/* /dev/sequencer, level 2 interface */
-#define SND_DEV_SNDPROC 9	/* /dev/sndproc for programmable devices */
-#define SND_DEV_PSS	SND_DEV_SNDPROC
-
-#define DSP_DEFAULT_SPEED	8000
-
-#define ON		1
-#define OFF		0
-
-#define MAX_AUDIO_DEV	5
-#define MAX_MIXER_DEV	2
-#define MAX_SYNTH_DEV	3
-#define MAX_MIDI_DEV	6
-#define MAX_TIMER_DEV	3

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
