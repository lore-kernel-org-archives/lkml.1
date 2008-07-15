Return-Path: <linux-kernel-owner+w=401wt.eu-S1753698AbYGOFJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbYGOFJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 01:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbYGOFJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 01:09:40 -0400
Received: from 1wt.eu ([62.212.114.60]:3974 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756198AbYGOFJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 01:09:39 -0400
Date: Tue, 15 Jul 2008 07:06:54 +0200
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel, use it in more drivers.
Message-ID: <20080715050654.GH1369@1wt.eu>
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org> <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org> <487C09EB.1050903@garzik.org> <alpine.LFD.1.10.0807141928540.3017@woody.linux-foundation.org> <487C1648.5070409@garzik.org> <alpine.LFD.1.10.0807142027140.3017@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807142027140.3017@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2008 at 08:29:13PM -0700, Linus Torvalds wrote:
> 
> 
> On Mon, 14 Jul 2008, Jeff Garzik wrote:
> > 
> > Do you really think embedded system and micro distro authors are in 100%
> > agreement that /lib/firmware is best for their situation?  Really?
> 
> Umm. Why are you bringing up these total red herrings?

It's not red herring, Linus. I (as a user, as an embedded system developer
and as a micro distro maintainer) do really care.

> Those embedded systems can just build everything into one image, and are 
> much better off using no modules at all.

While it is sometimes acceptable to have everything built into one image,
sometimes your embedded system is modular in that the same image works
on several hardware variants. In this case, it's largely preferable to
work with modules.

> But how about instead of complaining, help add the infrastructure then, so 
> that you can insert those firmware things into modules and still use just 
> one single interface? 

I think that would make everyone happy. It would be worth taking a
look at myri10ge version 1.4.2 to see how they managed to support
both mechanisms.

> Move _forward_, not backwards.

This is just a matter of point of view. From my POV, having to feed
several unrelated files into a system to be able to get it to support
any device is moving backwards, compared to the currently clean all-in-1
driver model.

BTW, I still did not understand what existing problem we are trying
to solve by this move "forward".

Willy

