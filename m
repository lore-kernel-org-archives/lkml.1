Return-Path: <linux-kernel-owner+w=401wt.eu-S1754427AbZD1UMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbZD1UMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 16:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbZD1UMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 16:12:23 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:54120 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbZD1UMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 16:12:23 -0400
To: tiwai@suse.de
CC: miklos@szeredi.hu, teheo@suse.de, linux-kernel@vger.kernel.org,
       greg@kroah.com, fuse-devel@lists.sourceforge.net
In-reply-to: <s5hfxfsr2uq.wl%tiwai@suse.de> (message from Takashi Iwai on Tue,
	28 Apr 2009 21:32:29 +0200)
Subject: Re: [ANNOUNCE] OSS Proxy 1.2 using CUSE
References: <48B6F711.1040604@kernel.org>
	<49E3F91E.4000801@suse.de>
	<E1Lypk4-0004it-BA@pomaz-ex.szeredi.hu>
	<s5hmya0spao.wl%tiwai@suse.de>
	<E1Lyqvi-0004vX-2G@pomaz-ex.szeredi.hu> <s5hfxfsr2uq.wl%tiwai@suse.de>
Message-Id: <E1Lytf8-0005LD-HJ@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 28 Apr 2009 22:12:18 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Apr 2009, Takashi Iwai wrote:
> At Tue, 28 Apr 2009 19:17:14 +0200,
> Miklos Szeredi wrote:
> > 
> > On Tue, 28 Apr 2009, Takashi Iwai wrote:
> > > Are you using pulse plugin for ALSA, too?
> > 
> > alsa-plugins-pulse package is installed.  How can I find out if ALSA
> > is actually using this plugin?
> 
> For example, if you start aplay with -v option, it'll show the plugins
> to use.

OK, it doesn't.  So I have to tweak some config files to make it use
this plugin...

...done.  Well, now things do work, but the sound quality is very
crappy when PA is mixing two or more streams together (loud cracking
that maybe sounds like integer overflow).

> > What is the disadvantage of non-native ALSA vs. native ALSA?
> 
> Well, the question is rather whether you need PA or not...

Yes, OSSP needs it.  So the question (to Tejun) is why does OSSP use
libpulse API instead of libalsa API?

The former seems to be much more mature and easier to configure than
the latter.

Thanks,
Miklos
