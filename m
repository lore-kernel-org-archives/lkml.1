Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481Ab0AZMuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab0AZMuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 07:50:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888Ab0AZMut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 07:50:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56428 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065Ab0AZMus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 07:50:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: sboyce@blueyonder.co.uk
Subject: Re: HDA Intel Audio hang on boot
Date: Tue, 26 Jan 2010 13:51:40 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: Takashi Iwai <tiwai@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera> <s5hr5pd9wsu.wl%tiwai@suse.de> <4B5ED9E4.60106@blueyonder.co.uk>
In-Reply-To: <4B5ED9E4.60106@blueyonder.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001261351.40292.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 January 2010, Sid Boyce wrote:
> On 26/01/10 06:58, Takashi Iwai wrote:
...
> > And... is this report for 2.6.32 or for 2.6.33?
> > If it's with 2.6.32, enable_msi=1 may help instead.
> > 
> > 
> The motherboard giving the problem is the Asus M2N32-SLI deluxe.
> 00:0e.1 Audio device: nVidia Corporation MCP55 High Definition Audio
> (rev a2)
> 
> No such problem with the Asus CROSSHAIR II FORMULA motherboard which
> also has the
> 00:07.0 Audio device: nVidia Corporation MCP72XE/MCP72P/MCP78U/MCP78S
> High Definition Audio (rev a1)
> 
> For any kernel >2.6.32-git1 it hangs, i.e 2.6.32-git2 to 2.6.33-rc5.
> Disabling the sound chip in the BIOS, they all boot.
> tindog:/etc/modprobe.d # uname -r
> 2.6.32-git1-smp
> tindog:/etc/modprobe.d # l /dev/dsp*
> crw-rw-rw- 1 root audio 14,  3 Jan 26 11:46 /dev/dsp
> crw-rw-rw- 1 root audio 14, 35 Jan 26 11:46 /dev/dsp2

Is your adapter build as a module or is it compiled directly into the kernel?

Rafael
