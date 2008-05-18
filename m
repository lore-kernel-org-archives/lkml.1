Return-Path: <linux-kernel-owner+w=401wt.eu-S1761100AbYEQXNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761100AbYEQXNY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 19:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbYEQXNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 19:13:17 -0400
Received: from mail.aknet.ru ([78.158.192.26]:58993 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbYEQXNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 19:13:17 -0400
Message-ID: <482F9EC3.8010907@aknet.ru>
Date: Sun, 18 May 2008 07:13:07 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dave Jones <davej@codemonkey.org.uk>
CC: Takashi Iwai <tiwai@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org
Subject: Re: [Bug #10679] 2.6.26-rc1 regression:	e5e1d3cb20034a3cbcfff1f0bae12201aa2ce17e
 breaks artsd
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <88YBFoyd1CN.A._sF.Ov1JIB@chimera> <s5hskwmeb1h.wl%tiwai@suse.de> <20080514212011.GH7054@mit.edu> <s5hhcd0azv1.wl%tiwai@suse.de> <20080515130654.GC18825@mit.edu> <s5h8wybr0c2.wl%tiwai@suse.de> <20080517204725.GA11460@codemonkey.org.uk>
In-Reply-To: <20080517204725.GA11460@codemonkey.org.uk>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Dave Jones wrote:
> More seriously, it doesn't seem that there's any way we can build
> this driver modular without it screwing up already working systems
Actually, I have just upgraded
f8->f9, and guess what? Lost the
sound... And not because of snd-pcsp,
but rather because snd-hda-intel
started to take the first slot
and snd-intel8x0 takes the second.
On f8 snd-hda-intel have never been
loaded for me at all. I don't need
it, it finds a HDA chip on an ATI
video board, which it never did before.

So... it doesn't look like this
problem is specific to snd-pcsp.
Anyone can get into that trouble
it seems.
