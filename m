Return-Path: <linux-kernel-owner+w=401wt.eu-S1759753AbXGCPUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759753AbXGCPUz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 11:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754358AbXGCPUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 11:20:46 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56576 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753738AbXGCPUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 11:20:45 -0400
Date: Tue, 3 Jul 2007 16:26:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Morten Helgesen <morten@sourcepoet.org>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] genericserial: Remove bogus optimisation check and dead
 code paths
Message-ID: <20070703162655.6a001fdc@the-village.bc.nu>
In-Reply-To: <468A5F89.70900@sourcepoet.org>
References: <20070703152021.6eb8013d@the-village.bc.nu>
	<468A5F89.70900@sourcepoet.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Jul 2007 16:39:05 +0200
Morten Helgesen <morten@sourcepoet.org> wrote:

> Alan Cox wrote:
> 
> [...snip...]
> > @@ -75,11 +64,11 @@
> >  	if (! (port->flags & ASYNC_INITIALIZED)) return;
> >  
> >  	/* Take a lock on the serial tranmit buffer! */
> > -	LOCKIT;
> > +	mutex_lock(& port->port_write_mutex);
> >   
> 
> ^ Contains additional whitespace.


Its an old driver, it doesn't follow the coding style too well at all -
viz stuff like if (! ( the line above. Given its age and limited userbase
I don't plan to go and make it conform either, but I will take patches
for the formatting (and the spelling errors it is full of) from someone
who wants to do the work.

Alan
