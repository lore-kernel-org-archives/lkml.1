Return-Path: <linux-kernel-owner+w=401wt.eu-S1761300AbYGOQF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761300AbYGOQF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 12:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752950AbYGOQFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 12:05:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:49350 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560AbYGOQFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 12:05:15 -0400
Date: Tue, 15 Jul 2008 09:04:41 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Frans Pop <elendil@planet.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, jeff@garzik.org,
       akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
 in-kernel, use it in more drivers.
Message-ID: <20080715090441.478c2287@infradead.org>
In-Reply-To: <200807151757.10626.elendil@planet.nl>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	<20080714164119.99c33d5b.akpm@linux-foundation.org>
	<20080714165956.7fe2d4ee@infradead.org>
	<487C0365.5030203@garzik.org>
	<487C0365.5030203@garzik.org>
	<alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
	<200807151757.10626.elendil@planet.nl>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008 17:57:09 +0200
Frans Pop <elendil@planet.nl> wrote:

> Linus Torvalds wrote:
> > On Mon, 14 Jul 2008, Jeff Garzik wrote:
> >> IMO the newly added /inability/ to build firmware into kernel
> >> modules is a clear regression.
> > 
> > IMO you're being stupid.
> > 
> > How about explainign why it makes any difference what-so-ever?
> > 
> > If you can load the module, you can load the firmware. Claiming
> > anything else is just _stupid_.
> 
> Sure, in theory it's that simple. Here's a concrete example that
> shows how things are harder in practice.
> 
> I use the 'make deb-pkg' target (from scripts/package) to build my
> Debian kernel packages from git. So that needs to be adapted to
> include /lib/firmware. No real problem so far.
> 
> So then I build 2.6.27-rc1 and install it. Great.
> 
> You release 2.6.27-rc2 and I build it. Ouch! It fails to install, at
> least if I want to install it _alongside_ 2.6.27-rc1 or other kernels
> (which I do!). Why does it fail? Because dpkg's package management
> does not allow one package to overwrite files already "owned" by
> another package.
> 

question: how do you deal with this with the dozens of drivers that use
request_firmware() even before yesterday ?
the answer is critical in how to deal with this "new" situation as
well ;-)
