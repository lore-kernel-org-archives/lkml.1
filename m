Return-Path: <linux-kernel-owner+w=401wt.eu-S1754054AbYLNH7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbYLNH7L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 02:59:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbYLNH65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 02:58:57 -0500
Received: from rv-out-0506.google.com ([209.85.198.227]:23603 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbYLNH65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 02:58:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=btQeWYdkB1ejHvPZBInRNQ9+NZBwhMJofEeJU6AN1etEDgKihchUiBfwNY7lyjAjIR
         kkr7YjpbCV99Oy6Czrx/HpASqCmDMMLPivrdTy/5Qx5ALGfbSu0NldhqkauZXg1aOAaZ
         bxAH28sl/sqhKdFbm7HK7fEhb2Zy/BpmUJ/KM=
Message-ID: <3f9a31f40812132358x27df1788re521e47b8dbe2cd1@mail.gmail.com>
Date: Sun, 14 Dec 2008 13:28:56 +0530
From: "Jaswinder Singh" <jaswinderlinux@gmail.com>
To: linux-kernel@vger.kernel.org, matt.jared@intel.com, andy.kopp@intel.com,
       dan.d.kogan@intel.com, tiwai@suse.de, pshou@realtek.com.tw
Subject: BUG - HDA Intel very low audio with breaking voice in 2.6.28-rc8
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I am facing problem in 2.6.28-rc8, HDA Intel audio is very low and
with breaking voice, may be it seems like HD effect ;)

dmesg :

HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
HDA Intel 0000:00:14.2: setting latency timer to 64
ALSA sound/pci/hda/hda_codec.c:3055: autoconfig: line_outs=1
(0xd/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:3059:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:3063:    hp_outs=1 (0xa/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:3064:    mono: mono_out=0x0
ALSA sound/pci/hda/hda_codec.c:3072:    inputs: mic=0xb, fmic=0x0,
line=0xe, fline=0x0, cd=0x0, aux=0x0
HDA Intel 0000:01:05.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
HDA Intel 0000:01:05.1: setting latency timer to 64

/sbin/lspci -vv :
00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia
	Subsystem: Hewlett-Packard Company Device 30f2
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Interrupt: pin ? routed to IRQ 16
	Region 0: Memory at d2400000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel


01:05.1 Audio device: ATI Technologies Inc RS780 Azalia controller
	Subsystem: Hewlett-Packard Company Device 30f2
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 0: Memory at d2310000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ Count=1/1 Enable-
		Address: 0000000000000000  Data: 0000
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

If you need more information, please let me know.

I am also curious why it is showing 2 audio devices with lspci. I am
using HP dv5-1002us laptop.

Thank you,

Jaswinder Singh.
