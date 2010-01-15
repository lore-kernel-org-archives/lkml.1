Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772Ab0AOQq0 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 11:46:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756942Ab0AOQqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 11:46:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753549Ab0AOQqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 11:46:25 -0500
Date: Fri, 15 Jan 2010 08:46:03 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Nick Bowler <nbowler@elliptictech.com>
cc: Thomas Meyer <thomas@m3y3r.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Nick Bowler <nbowler@draconx.ca>, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] drm/i915: disable LVDS downclock by default
In-Reply-To: <20100115163246.GA4498@emergent.ellipticsemi.com>
Message-ID: <alpine.LFD.2.00.1001150842050.13231@localhost.localdomain>
References: <alpine.LFD.2.00.1001122139411.17145@localhost.localdomain> <20100113133357.67f9df6d@jbarnes-piketon> <4B4E403C.1050509@cs.helsinki.fi> <20100113165530.2a7e7645@jbarnes-piketon> <4B4F6D5F.10008@cs.helsinki.fi> <84144f021001150054m532cd1cdwbbdbab79b5924fb7@mail.gmail.com>
 <1263572080.2217.1.camel@localhost.localdomain> <20100115163246.GA4498@emergent.ellipticsemi.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 15 Jan 2010, Nick Bowler wrote:
> 
> You could apply Jesse's patch at each step during the bisection whenever
> the LVDS downclocking commit is present.

There's even a use "git bisect run" to automate it, see "man git-bisect".

Although in all fairness, for a one-off bisect like this, it's usually 
more pain to write the automation script than to just do it manually the 
handful of times you need to. You need to return a special value to say "I 
need to test this specially" - since "git bisect run" is designed to also 
return the 'is it good or bad' test value.

			Linus
