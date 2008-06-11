Return-Path: <linux-kernel-owner+w=401wt.eu-S1761310AbYFKSJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761310AbYFKSJs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 14:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755195AbYFKSJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 14:09:39 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:6395 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178AbYFKSJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 14:09:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=MAkGpZ35RUzcGzhcb9v/ffnI4tL1MSwxxf9QHTV6zvjPjr1Uau7KPst42jLgpwjfDL
         qC22ijZfesKSEZlDSd62SDoy+3LxUAO+pIFalSIvm1lUuOCU8DEc94ZsGyz/sB2nzTbq
         jyKob3utMXcQlWpkOlItbY4pWXmMv4iIst2Xo=
From: arjenpool@gmail.com
To: linux-kernel@vger.kernel.org
Subject: Cant compile 2.6.26-rc5-mm2 kernel
Date: Wed, 11 Jun 2008 20:08:56 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806112008.56478.arjenpool@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For whom it concerns:

Hello!

Today i`ve tried to compile a linux-2.6.26-rc5-mm2 kernel obtained with the 
Ketchup tool.
 
It got halfway interupted with the following error messages:

CC [M] fs/xfs/support/debug.o
 CC [M] fs/xfs/support/uuid.o
 LD [M] fs/xfs/xfs.o
 CC fs/quota.o
fs/quota.c: In function 'quota_sync_sb':
fs/quota.c:174: error: implicit declaration of function 'sb_dqopt'
fs/quota.c:174: error: invalid type argument of '->'
fs/quota.c:180: error: invalid type argument of '->'
fs/quota.c:181: error: invalid type argument of '->'
fs/quota.c:182: error: invalid type argument of '->'
fs/quota.c:184: error: invalid type argument of '->'
fs/quota.c: In function 'sync_dquots':
fs/quota.c:206: error: invalid type argument of '->'
fs/quota.c:207: error: invalid type argument of '->'
fs/quota.c: In function 'do_quotactl':
fs/quota.c:247: error: invalid type argument of '->'
fs/quota.c:249: error: invalid type argument of '->'
fs/quota.c:252: error: invalid type argument of '->'
fs/quota.c:253: error: invalid type argument of '->'
make[1]: *** [fs/quota.o] Error 1
make: *** [fs] Error 2

I have made 5 attempts to recompile the source with the same result.

Here is the output of the ver_linux script as i understand it may be helpfull:

Linux raptor 2.6.24-gentoo-r8 #2 SMP PREEMPT Thu Jun 5 16:16:17 CEST 2008 i686 
Genuine Intel(R) CPU T2080 @ 1.73GHz GenuineIntel GNU/Linux
Gnu C 4.1.2
Gnu make 3.81
binutils 2.18
util-linux 2.13.1.1
mount 2.13.1.1
module-init-tools 3.4
e2fsprogs 1.40.9
reiserfsprogs 3.6.19
pcmciautils 014
Linux C Library 2.6.1
Dynamic linker (ldd) 2.6.1
Procps 3.2.7
Net-tools 1.60
Kbd 1.13
Sh-utils 6.10
udev 119
wireless-tools 29
Modules Loaded ipv6 af_packet snd_pcm_oss snd_mixer_oss snd_seq_dummy 
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device usbmouse pcmcia usbhid 
hid joydev arc4 ecb pcspkr psmouse blkcipher yenta_socket serio_raw sdhci 
rsrc_nonstatic mmc_core ehci_hcd uhci_hcd pcmcia_core i2c_i801 ath5k usbcore 
mac80211 cfg80211 snd_hda_intel snd_pcm snd_timer snd video battery container 
ac thermal output nvidia soundcore processor button snd_page_alloc intel_agp 
agpgart i2c_core evdev

I hope this is enough information to work with. 
if there is more, im happy to provde it.

Arjen Pool

arjenpool@gmail.com
