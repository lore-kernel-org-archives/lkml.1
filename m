Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025AbXIOKQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbXIOKQy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 06:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755146AbXIOKQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 06:16:47 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:54591 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738AbXIOKQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 06:16:46 -0400
Date: Sat, 15 Sep 2007 12:18:11 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Takashi Iwai <tiwai@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add consts where appropriate in sound/pci/hda/*
Message-ID: <20070915101811.GA9934@uranus.ravnborg.org>
References: <200709141848.06027.vda.linux@googlemail.com> <Pine.LNX.4.64.0709151143230.13411@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709151143230.13411@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 15, 2007 at 11:43:40AM +0200, Jan Engelhardt wrote:
> 
> On Sep 14 2007 18:48, Denys Vlasenko wrote:
> >Hi Takashi,
> >
> >There is a lot of data structures in that code,
> >and most of them seems to be read-only.
> >
> >I added const modifiers to most of such places:
> >
> >   text    data     bss     dec     hex filename
> > 106315  179564      36  285915   45cdb snd-hda-intel.o
> > 283051    2624      36  285711   45c0f snd-hda-intel_patched.o
> 
> This is kinda odd. Why did the _text_ size increase by constifying?

The data got converted from data to text because they were made const.
Making stuff const unfortunately does not make them disappear
albeit the embedded folks would have liked that.

	Sam
