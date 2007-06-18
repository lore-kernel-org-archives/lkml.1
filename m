Return-Path: <linux-kernel-owner+w=401wt.eu-S1762854AbXFRQh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762854AbXFRQh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 12:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754833AbXFRQhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 12:37:16 -0400
Received: from lug.demon.co.uk ([83.104.159.110]:35766 "EHLO
	mango.david-web.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753310AbXFRQhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 12:37:15 -0400
From: David Johnson <dj@david-web.co.uk>
Reply-To: linux-kernel@vger.kernel.org
To: linux-kernel@vger.kernel.org
Subject: Re: Sound plays at half speed; intel8x0 clock issue
Date: Mon, 18 Jun 2007 17:37:04 +0100
User-Agent: KMail/1.9.5
References: <200706181337.43868.dj@david-web.co.uk> <20070618162354.GA32754@saeurebad.de>
In-Reply-To: <20070618162354.GA32754@saeurebad.de>
Cc: Jaroslav Kysela <perex@suse.cz>,
       Johannes Weiner <hannes-kernel@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706181737.04823.dj@david-web.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 June 2007 17:23, Johannes Weiner wrote:
>
> Could you give the output of
>
> 	lspci -vv -s 00:04.0
>

00:04.0 Multimedia audio controller: nVidia Corporation CK804 AC'97 Audio 
Controller (rev a2)
        Subsystem: Foxconn International, Inc. Unknown device 0ca2
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 20
        Region 0: I/O ports at f000 [size=256]
        Region 1: I/O ports at ec00 [size=256]
        Region 2: Memory at fe02d000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

> and
> 	cat /proc/asound/card0/codec97#0/ac97#0-0
>

0-0/0: Realtek ALC850 rev 0

PCI Subsys Vendor: 0x105b
PCI Subsys Device: 0x0ca2

Revision         : 0x00
Compat. Class    : 0x00
Subsys. Vendor ID: 0xffff
Subsys. ID       : 0xffff

Capabilities     :
DAC resolution   : 16-bit
ADC resolution   : 16-bit
3D enhancement   : No 3D Stereo Enhancement

Current setup
Mic gain         : +0dB [+0dB]
POP path         : pre 3D
Sim. stereo      : off
3D enhancement   : off
Loudness         : off
Mono output      : MIX
Mic select       : Mic1
ADC/DAC loopback : off
Double rate slots: 7/8
Extended ID      : codec=0 rev=2 LDAC SDAC CDAC DSA=0 SPDIF DRA
Extended status  : SPCV LDAC SDAC CDAC SPDIF=10/11
SPDIF Control    : Consumer PCM Category=0x2 Generation=1 Rate=48kHz

Many thanks for your help thus far.

Regards,
David.

-- 
David Johnson
www.david-web.co.uk
