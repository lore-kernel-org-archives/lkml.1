Return-Path: <linux-kernel-owner+w=401wt.eu-S1762462AbXK2CfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762462AbXK2CfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 21:35:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761923AbXK2Cet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 21:34:49 -0500
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:33590 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761856AbXK2Ces (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 21:34:48 -0500
Date: Thu, 29 Nov 2007 03:34:47 +0100 (CET)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix plip 1
In-Reply-To: <alpine.LFD.0.9999.0711261929560.5869@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0711290332240.4939@artax.karlin.mff.cuni.cz>
References: <Pine.LNX.4.64.0711222053170.15336@artax.karlin.mff.cuni.cz>
 <alpine.LFD.0.9999.0711261929560.5869@woody.linux-foundation.org>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 26 Nov 2007, Linus Torvalds wrote:

> 
> 
> On Thu, 22 Nov 2007, Mikulas Patocka wrote:
> > 
> > netif_rx is meant to be called from interrupts because it doesn't wake up 
> > ksoftirqd. For calling from outside interrupts, netif_rx_ni exists.
> 
> Argh. Can you _please_ use more useful subject lines than "fix plip 1/2"?
> 
> Those subject lines are what becomes the single-line description of the 
> problem, used by visualizers like gitk and gitweb. So "fix plip 1" is a 
> singularly bad such line!

OK, I see

Mikulas
