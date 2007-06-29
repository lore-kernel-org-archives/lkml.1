Return-Path: <linux-kernel-owner+w=401wt.eu-S1764325AbXF2Lwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764325AbXF2Lwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 07:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760404AbXF2Lwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 07:52:47 -0400
Received: from mail.gmx.net ([213.165.64.20]:46882 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758556AbXF2Lwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 07:52:46 -0400
X-Authenticated: #4399952
X-Provags-ID: V01U2FsdGVkX1/8GwZpkDH8E11qNX0cbxcAieqYCN+ihbEeZOwnhc
	16sVtrcnpzLR/m
From: Florian Schmidt <mista.tapas@gmx.net>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
Date: Fri, 29 Jun 2007 13:52:42 +0200
User-Agent: KMail/1.9.6
Cc: Nix <nix@esperi.org.uk>, Olivier Galibert <galibert@pobox.com>,
       Takashi Iwai <tiwai@suse.de>,
       Tomasz K?oczko <kloczek@rudy.mif.pg.gda.pl>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <20070624200837.16e11305@the-village.bc.nu> <87tzssextf.fsf@hades.wkstn.nix> <20070628210614.GC6087@stusta.de>
In-Reply-To: <20070628210614.GC6087@stusta.de>
X-Face: %EpW[IH18fBP*R?oz~]%Klbl.q!_(Xs_q"t?K~RVx[c7~3|C3kDdA(8y_KOB\{(Rn(=?utf-8?q?MZhm=0A=09=7B/l=2E?=>O48>i9k<+(,c^Y%mGm)M\+RxuxL4r<7-W63sB$+w\}hkT"Q2?v&N:y\Z
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706291352.42833.mista.tapas@gmx.net>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 June 2007, Adrian Bunk wrote:

> There is also a userspace OSS emulation for ALSA not suffering from
> these problems.

Yeah, it suffers from other problems though. It uses an LD_PRELOAD hack to 
intercept library calls that open the /dev/dsp devices etc.. This doesn't 
always work.

I suppose the best way to provide OSS emu is to use something like FUSD 
[similar to the OSS2JACK package] [1] to provide the OSS device files and 
then redirect to user space, so all ALSA pcm devices can be used.. Sadly FUSD 
doesn't really get actively developed anymore it seems. And FUSE can't handle 
ioctls.

[1] http://www.circlemud.org/~jelson/software/fusd/

Regards,
Flo

-- 
Palimm Palimm!
http://tapas.affenbande.org
