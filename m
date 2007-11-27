Return-Path: <linux-kernel-owner+w=401wt.eu-S1755751AbXK0DdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751AbXK0DdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 22:33:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbXK0Dc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 22:32:59 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50358 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754009AbXK0Dc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 22:32:58 -0500
Date: Mon, 26 Nov 2007 19:32:54 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix plip 1
In-Reply-To: <Pine.LNX.4.64.0711222053170.15336@artax.karlin.mff.cuni.cz>
Message-ID: <alpine.LFD.0.9999.0711261929560.5869@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0711222053170.15336@artax.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 22 Nov 2007, Mikulas Patocka wrote:
> 
> netif_rx is meant to be called from interrupts because it doesn't wake up 
> ksoftirqd. For calling from outside interrupts, netif_rx_ni exists.

Argh. Can you _please_ use more useful subject lines than "fix plip 1/2"?

Those subject lines are what becomes the single-line description of the 
problem, used by visualizers like gitk and gitweb. So "fix plip 1" is a 
singularly bad such line!

Which is why it should be something like

	Subject: [PATCH 1/2] plip: use netif_rx_ni() for packet receive

or similar.. (My scripts will then get rid of the stuff in brackets, so 
all that is useful for giving information that is interesting while in 
*email*, but not when actually applied as a patch)

		Linus
