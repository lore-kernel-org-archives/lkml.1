Return-Path: <linux-kernel-owner+w=401wt.eu-S932378AbZFINSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378AbZFINSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 09:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757515AbZFINSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 09:18:08 -0400
Received: from relais.videotron.ca ([24.201.245.36]:54759 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621AbZFINSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 09:18:07 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Tue, 09 Jun 2009 09:18:00 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the watchdog tree with the arm tree
In-reply-to: <20090609123914.GD16090@infomag.iguana.be>
Message-id: <alpine.LFD.2.00.0906090913520.31536@xanadu.home>
References: <20090609163718.ccefad1d.sfr@canb.auug.org.au>
 <20090609123914.GD16090@infomag.iguana.be>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jun 2009, Wim Van Sebroeck wrote:

> Hi Stephen,
> 
> > Today's linux-next merge of the watchdog tree got a conflict in
> > drivers/watchdog/Makefile between commit
> > 3b937a7dbddbedd9457b33fcc8fa369c0c229c6e ("[ARM] Orion/Kirkwood: rename
> > orion5x_wdt to orion_wdt") from the arm tree and commit
> > e35f878d8313518a20d3c53393d14761dca74624 ("[WATCHDOG] U300 COH 901 327
> > watchdog driver") from the watchdog tree.
> 
> It would have been nice if the orion watchdog rename patch would have been
> sent to the watchdog maintainer also...

The patch has implications touching 2 different ARM subarchitectures 
outside the driver itself, so I felt it more appropriate for the rename 
to happen all at once and be carried through the ARM tree.  The driver 
sees no functional changes.
But I agree that I could have sent you a note.

> > Just context changes.  I fixed it up (see below) and can carry the fix as
> > necessary.
> 
> I'll have a look at the commit and might pull it into the watchdog tree also.
> That way you shouldn't have any problem with it.

I don't think it'll apply cleanly to the watchdog tree without greater 
conflicts with the other ARM related changes.


Nicolas
