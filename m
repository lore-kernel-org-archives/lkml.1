Return-Path: <linux-kernel-owner+w=401wt.eu-S1760427AbZDFWUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760427AbZDFWUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 18:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760220AbZDFWUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 18:20:14 -0400
Received: from mail.sdinet.de ([78.47.32.153]:58108 "EHLO mail.sdinet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760361AbZDFWUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 18:20:12 -0400
X-Greylist: delayed 603 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Apr 2009 18:20:11 EDT
Date: Tue, 7 Apr 2009 00:09:31 +0200 (CEST)
From: Sven-Haegar Koch <haegar@sdinet.de>
To: Matt Mackall <mpm@selenic.com>
cc: Robin Getz <rgetz@blackfin.uclinux.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Chris Peterson <cpeterso@cpeterso.com>
Subject: Re: IRQF_SAMPLE_RANDOM question...
In-Reply-To: <1239044483.14392.55.camel@calx>
Message-ID: <alpine.DEB.2.00.0904070003470.6968@aurora.sdinet.de>
References: <200904061430.26276.rgetz@blackfin.uclinux.org> <1239044483.14392.55.camel@calx>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Apr 2009, Matt Mackall wrote:

> On Mon, 2009-04-06 at 14:30 -0400, Robin Getz wrote:
> > We have lots of embedded headless systems (no keyboard/mouse, no soundcard, no 
> > video) systems with *no* sources of entropy - and people using SSL.
> 
> I'd rather add a random_sample_network call somewhere reasonably central
> in the network stack. Then we can use the knowledge that the sample is
> network-connected in the random core to decide how to measure its
> entropy. The trouble with IRQF_SAMPLE_RANDOM is that many of its users
> are technically bogus as entropy sources in the current model.
> 
> I'm eventually going to move the RNG away from the strict theoretical
> entropy accounting model to a more pragmatic one which will be much
> happier with iffy entropy sources, but that's a ways off.

Btw, perhaps not the perfect question in this thread:
But what should we use to keep servers running without a hardware rng 
available and without any external input besides the network?
After having ssh and openvpn die because of no random and having 
the machines like dead and unreachable for me I use "ln -sf 
/dev/urandom /dev/random", but that does not feel so good.

c'ya
sven

-- 
The lights are fading out, once more...
