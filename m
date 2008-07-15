Return-Path: <linux-kernel-owner+w=401wt.eu-S1761551AbYGOQRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761551AbYGOQRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 12:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbYGOQR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 12:17:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42421 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750837AbYGOQR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 12:17:28 -0400
Date: Tue, 15 Jul 2008 09:15:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Frans Pop <elendil@planet.nl>
cc: jeff@garzik.org, arjan@infradead.org, akpm@linux-foundation.org,
       dwmw2@infradead.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <200807151757.10626.elendil@planet.nl>
Message-ID: <alpine.LFD.1.10.0807150913590.3017@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org> <487C0365.5030203@garzik.org> <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
 <200807151757.10626.elendil@planet.nl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Frans Pop wrote:
> 
> So, how is this solved by Debian for already existing firmware packages? 
> Basically by making a separate package for each firmware file (or 
> driver). This works because there are not too many of them, but having a 
> huge number of tiny packages is a nightmare by itself.

Why don't you just take the kernel-supplied firmware and make it part of 
the kernel package? The same way the kernel-supplied modules are part of 
it?

You're sounding like

  "Mommy, mommy, it hurts when I repeatedly hit my head against the wall 
   and stick forks in my eyes!"

and quite frankly, it doesn't make me go "Oh, poor baby" at all.

			Linus
