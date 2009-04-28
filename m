Return-Path: <linux-kernel-owner+w=401wt.eu-S1758266AbZD1Xf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbZD1Xf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 19:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755037AbZD1XfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 19:35:14 -0400
Received: from cantor.suse.de ([195.135.220.2]:41201 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754718AbZD1XfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 19:35:13 -0400
Message-ID: <49F792A5.2070202@suse.de>
Date: Wed, 29 Apr 2009 08:35:01 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: tiwai@suse.de, linux-kernel@vger.kernel.org, greg@kroah.com,
       fuse-devel@lists.sourceforge.net
Subject: Re: [ANNOUNCE] OSS Proxy 1.2 using CUSE
References: <48B6F711.1040604@kernel.org>	<49E3F91E.4000801@suse.de>	<E1Lypk4-0004it-BA@pomaz-ex.szeredi.hu>	<s5hmya0spao.wl%tiwai@suse.de>	<E1Lyqvi-0004vX-2G@pomaz-ex.szeredi.hu> <s5hfxfsr2uq.wl%tiwai@suse.de> <E1Lytf8-0005LD-HJ@pomaz-ex.szeredi.hu>
In-Reply-To: <E1Lytf8-0005LD-HJ@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Miklos.

Miklos Szeredi wrote:
>> For example, if you start aplay with -v option, it'll show the plugins
>> to use.
> 
> OK, it doesn't.  So I have to tweak some config files to make it use
> this plugin...
> 
> ...done.  Well, now things do work, but the sound quality is very
> crappy when PA is mixing two or more streams together (loud cracking
> that maybe sounds like integer overflow).

Which version are you using, it got better and then worse and then
better again IIRC.  Yeah, it's still in the process of maturing.

>>> What is the disadvantage of non-native ALSA vs. native ALSA?
>> Well, the question is rather whether you need PA or not...
> 
> Yes, OSSP needs it.  So the question (to Tejun) is why does OSSP use
> libpulse API instead of libalsa API?
> 
> The former seems to be much more mature and easier to configure than
> the latter.

On default installation of any recent major distros, PA is the default
and ALSA via PA is the default too, so the configuration doesn't
matter at all.  I think PA is the way to go (all other guys are
already there) && we're past the point of no return at this point &&
it's nicer to program to and has some features I wanted (per-pgrp
volume for example), so...

Thanks.

-- 
tejun
