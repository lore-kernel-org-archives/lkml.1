Return-Path: <linux-kernel-owner+w=401wt.eu-S1761946AbYGOQhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761946AbYGOQhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 12:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760926AbYGOQhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 12:37:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47161 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760686AbYGOQhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 12:37:08 -0400
Date: Tue, 15 Jul 2008 09:35:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Frans Pop <elendil@planet.nl>
cc: jeff@garzik.org, arjan@infradead.org, akpm@linux-foundation.org,
       dwmw2@infradead.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <alpine.LFD.1.10.0807150913590.3017@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807150931010.3017@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org> <487C0365.5030203@garzik.org> <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
 <200807151757.10626.elendil@planet.nl> <alpine.LFD.1.10.0807150913590.3017@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Linus Torvalds wrote:
> 
> Why don't you just take the kernel-supplied firmware and make it part of 
> the kernel package? The same way the kernel-supplied modules are part of 
> it?

And, btw, if there is something we can do to help, we obviously should.

So ask yourself (and DavidW) things like

 - Is "make firmware_install" not enough for the package build system?

 - Does it need some other way to figure out what firmware is needed for 
   just the configured set of drivers, eg "make firmware_list"?

 - Do we need to make the firmware loader have multiple directories it 
   looks at? Do we want first a kernel-version-specific one, then a 
   generic fallback one, so that we can easily have per-kernel firmware, 
   the same way we have per-kernel modules?

 - Add your interesting question here.

There are obviously all these kinds of _productive_ questions you can ask. 
But people seem to be mostly in an unproductive "Mommy, it hurts when I do 
something stupid" mode.

			Linus
