Return-Path: <linux-kernel-owner+w=401wt.eu-S1760220AbXJQSR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760220AbXJQSR4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 14:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757846AbXJQSRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 14:17:48 -0400
Received: from www17.your-server.de ([213.133.104.17]:52318 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757119AbXJQSRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 14:17:47 -0400
Message-ID: <471651C4.20907@m3y3r.de>
Date: Wed, 17 Oct 2007 20:17:40 +0200
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: hda-intel: no soundcard with current linus' git tree
References: <471538C2.80806@m3y3r.de> <s5h8x622kui.wl%tiwai@suse.de>
In-Reply-To: <s5h8x622kui.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai schrieb:
> At Wed, 17 Oct 2007 00:18:42 +0200,
> Thomas Meyer wrote:
>   
>> $ dmesg
>>
>> [schnipp]
>>
>> ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 21
>> PCI: Enabling bus mastering for device 0000:00:1b.0
>> PCI: Setting latency timer of device 0000:00:1b.0 to 64
>> hda_codec: STAC922x, Apple subsys_id=106b0200
>> ACPI: PCI interrupt for device 0000:00:1b.0 disabled
>> HDA Intel: probe of 0000:00:1b.0 failed with error -16
>>     
>
> It's EBUSY, so something conflict.
> Try to build with CONFIG_SND_DEBUG=y (and CONFIG_SND_DEBUG_DETECT=y).
>
>
>   
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 21
PCI: Enabling bus mastering for device 0000:00:1b.0
PCI: Setting latency timer of device 0000:00:1b.0 to 64
ALSA sound/pci/hda/hda_intel.c:727: codec_mask = 0x1
ALSA sound/pci/hda/hda_codec.c:2163: hda_codec: model 'intel-mac-v3' is
selected for config 8384:7680 (Mac Mini)
hda_codec: STAC922x, Apple subsys_id=106b0200
ALSA sound/pci/hda/patch_sigmatel.c:1283: hda_codec: pin nid 0a pin
config 0121e21f
ALSA sound/pci/hda/patch_sigmatel.c:1283: hda_codec: pin nid 0b pin
config 90a7012e
ALSA sound/pci/hda/patch_sigmatel.c:1283: hda_codec: pin nid 0c pin
config 9017e110
ALSA sound/pci/hda/patch_sigmatel.c:1283: hda_codec: pin nid 0d pin
config 400000fd
ALSA sound/pci/hda/patch_sigmatel.c:1283: hda_codec: pin nid 0e pin
config 400000fe
ALSA sound/pci/hda/patch_sigmatel.c:1283: hda_codec: pin nid 0f pin
config 0181e020
ALSA sound/pci/hda/patch_sigmatel.c:1283: hda_codec: pin nid 10 pin
config 1145e230
ALSA sound/pci/hda/patch_sigmatel.c:1283: hda_codec: pin nid 11 pin
config 11c5e240
usb 2-2: new full speed USB device using uhci_hcd and address 2
ALSA sound/pci/hda/patch_sigmatel.c:1283: hda_codec: pin nid 15 pin
config 400000fc
ALSA sound/pci/hda/patch_sigmatel.c:1283: hda_codec: pin nid 1b pin
config 400000fb
Clocksource tsc unstable (delta = -101396678 ns)
ALSA sound/pci/hda/hda_codec.c:2757: autoconfig: line_outs=1
(0xc/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:2761:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:2765:    hp_outs=1 (0xa/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:2773:    inputs: mic=0xb, fmic=0x0,
line=0xf, fline=0x0, cd=0x0, aux=0x0
ALSA sound/pci/hda/patch_sigmatel.c:1656: stac92xx_add_dyn_out_pins:
total dac count=4
ALSA sound/pci/hda/patch_sigmatel.c:1779: dac_nids=3 (0x3/0x5/0x4/0x0/0x0)
usb 2-2: configuration #1 chosen from 1 choice
ALSA sound/core/control.c:331: control 2:0:0:Master Playback Volume:0 is
already present
ACPI: PCI interrupt for device 0000:00:1b.0 disabled
HDA Intel: probe of 0000:00:1b.0 failed with error -16

$ cat /proc/asound/cards
--- no soundcards ---

$ cat /proc/asound/devices
  2:        : timer
  3:        : sequencer



mfg
thomas

