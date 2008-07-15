Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbYGOSZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbYGOSZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 14:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756092AbYGOSZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:25:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43132 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755798AbYGOSZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:25:08 -0400
Date: Tue, 15 Jul 2008 11:24:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Frans Pop <elendil@planet.nl>, arjan@infradead.org,
       akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <487CE917.3000000@garzik.org>
Message-ID: <alpine.LFD.1.10.0807151122010.3017@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org> <487C0365.5030203@garzik.org> <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
 <200807151757.10626.elendil@planet.nl> <20080715180535.GA6080@khazad-dum.debian.net> <487CE917.3000000@garzik.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Jeff Garzik wrote:

> Henrique de Moraes Holschuh wrote:
> > On Tue, 15 Jul 2008, Frans Pop wrote:
> > > If I were able to compile firmware into the modules, the problem would be
> > > solved in one go.
> > 
> > And this thread would have been shorter, even. I hope someone decides to
> > write that support instead of complaining ;-)
> 
> I've volunteered -- but if Linus and David will reject my code out of hand,
> there is not much point in writing it.

Quite frankly, I don't think it's something to reject out of hand, but it 
does sound pretty damn stupid.

Why compile them into the module, when that's just the _inflexible_ model?

Why not just install them with the module (perhaps in the module 
directory, perhaps not), and just load them? 

Really. You _do_ have do to "make modules_install" or similar. That has 
_already_ got inter-file dependencies (ie some modules simply depend on 
other modules). I'm not seeing why you cannot accept change.

			Linus
