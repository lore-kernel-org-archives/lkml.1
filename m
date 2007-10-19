Return-Path: <linux-kernel-owner+w=401wt.eu-S1764375AbXJSKqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764375AbXJSKqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 06:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756418AbXJSKqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 06:46:30 -0400
Received: from mail.gmx.net ([213.165.64.20]:53542 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755781AbXJSKq3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 06:46:29 -0400
X-Authenticated: #7313500
X-Provags-ID: V01U2FsdGVkX19tQZ9VSeht0Ve2L8IueKbKIcvROMuobN8eGHfzBC
	jcpSDHcvS4FcqG
From: Jan-Simon =?iso-8859-1?q?M=F6ller?= <dl9pf@gmx.de>
To: alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] hda-intel: no soundcard with current linus' =?iso-8859-1?q?git=09tree?=
Date: Fri, 19 Oct 2007 12:46:34 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Takashi Iwai <tiwai@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <471538C2.80806@m3y3r.de> <200710181819.25496.dl9pf@gmx.de> <s5hir53elsd.wl%tiwai@suse.de>
In-Reply-To: <s5hir53elsd.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710191246.34401.dl9pf@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 19 Oktober 2007 07:05:54 schrieb Takashi Iwai:
>
> Try model=fujitsu or model=laptop.  This will activate the
> auto-muting.

model=laptop worked, model=fujitsu did not.

> If it works, let me know the PCI SSID (from the output of lspci -vv).

I did already, here's the copy:

00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio 
Controller (rev 03)
        Subsystem: Fujitsu Siemens Computer GmbH Unknown device 110e
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 22
        Region 0: Memory at fc400000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [70] Express Unknown type IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed unknown, Width x0, ASPM unknown, Port 0
                Link: Latency L0s <64ns, L1 <1us
                Link: ASPM Disabled CommClk- ExtSynch-
                Link: Speed unknown, Width x0
        Capabilities: [100] Virtual Channel
        Capabilities: [130] Unknown (5)



Model name is FSC Esprimo Mobile Edition9 V5505 T7300, details here:
http://www.notebookzentrale.de/eshop.php?action=article_detail&s_supplier_aid=1366417&position=9&anzahl_treffer=9


Thanks again, great work! I patched my 10.3 default kernel and it works 
also :D . Linux is great - have phun !

Best regards
Jan-Simon Möller
