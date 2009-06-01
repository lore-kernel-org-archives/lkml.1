Return-Path: <linux-kernel-owner+w=401wt.eu-S1757578AbZFAUvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578AbZFAUvp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 16:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759337AbZFAUve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 16:51:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56263 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759329AbZFAUvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 16:51:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Fix floppy hibernation
Date: Mon, 1 Jun 2009 22:52:02 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Ondrej Zary <linux@rainbow-software.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <200905301804.26762.linux@rainbow-software.org> <20090601114342.GA2454@elf.ucw.cz> <20090601195159.GC29610@elte.hu>
In-Reply-To: <20090601195159.GC29610@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906012252.02862.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 June 2009, Ingo Molnar wrote:
> 
> * Pavel Machek <pavel@ucw.cz> wrote:
> 
> > On Sat 2009-05-30 18:04:25, Ondrej Zary wrote:
> > > Hello,
> > > floppy driver was always missing hibernation support. After resume, floppy did
> > > not work (until a couple of disk reinserts and retries), producing errors like
> > > this:
> > > end_request: I/O error, dev fd0, sector 0
> > > 
> > > Ingo Molnar tried to fix it in 2006: http://lkml.org/lkml/2006/11/12/92
> > > 
> > > 
> > > 
> > > 
> > > Based on Ingo Molnar's patch from 2006, this makes the floppy work after
> > > resume from hibernation, at least on my machine.
> > > 
> > > 
> > > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> > Acked-by: Pavel Machek <pavel@ucw.cz>
> 
> nice patch ... thanks for picking up what i left unfinished.

I guess I'll take it to the suspend tree.  Or is it a better place?

Best,
Rafael
