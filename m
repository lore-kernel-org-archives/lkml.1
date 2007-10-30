Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942AbXJ3CzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbXJ3CzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 22:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbXJ3CzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 22:55:10 -0400
Received: from ag-out-0708.google.com ([72.14.246.240]:53586 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbXJ3CzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 22:55:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=ainbz2wp0JDYeZpvV0mmTRdClpb8Q4tOxnFINkEaTxmuMNV8AaGfhF95/+pFvQfC55w/Fx6QSomajzIv87xRVVPYrdhqw3/hEsHLuFnkzB20HxPiO2+peUDa17s/FMRJvc+ttkoWOIW4J7pLQ+feMKKQiTKirIBW+RI+I3942zg=
Date: Mon, 29 Oct 2007 21:54:54 -0500
From: Josh Boyer <jwboyer@gmail.com>
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: Stefan Roese <stefan.roese@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Bootup support for watchdog with short timeout
 (touch_nmi_watchdog()?)
Message-ID: <20071029215454.0d644ca7@vader.jdub.homelinux.org>
In-Reply-To: <20071029194503.GB27646@csclub.uwaterloo.ca>
References: <200710291522.27311.stefan.roese@gmail.com>
	<20071029194503.GB27646@csclub.uwaterloo.ca>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007 15:45:03 -0400
lsorense@csclub.uwaterloo.ca (Lennart Sorensen) wrote:

> On Mon, Oct 29, 2007 at 03:22:27PM +0100, Stefan Roese wrote:
> > I'm trying to implement support for a board specific watchdog on a PPC440EPx 
> > board with a very short timeout. In this case, the watchdog has to 
> > be "kicked" at least every 100ms, even while booting and the real watchdog 
> > driver not running yet. While looking for trigger places in the kernel 
> > source, I noticed the already existing "touch_nmi_watchdog()" function, which 
> > seems to be doing what I need. Even if the name not exactly matches my 
> > hardware setup.
> > 
> > My question now is, is it recommended to use this 
> > touch_nmi_watchdog() "infrastructure" for my PPC custom specific watchdog 
> > during bootup? And if yes, should it perhaps be renamed to a more generic 
> > name, like "touch_watchdog"?
> > 
> > Please advise. Thanks.
> 
> No idea really.  Who would design a watchdog with such a short trigger
> time?  That doesn't seem to be useful in any way.

To some degree, it's configurable.  But the generic question still
stands.  It seems like a decent idea to me.  Making touch_watchdog (or
whatever it winds up being called) nice across arches might be fun.

josh
