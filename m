Return-Path: <linux-kernel-owner+w=401wt.eu-S1754222AbXLDVsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbXLDVsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:48:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbXLDVry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:47:54 -0500
Received: from smtp.ono.com ([62.42.230.12]:33797 "EHLO resmaa02.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751821AbXLDVrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:47:53 -0500
Date: Tue, 4 Dec 2007 22:47:45 +0100
From: "J.A. =?ISO-8859-1?Q?Magall=F3n?=" <jamagallon@ono.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Kernel Development & Objective-C
Message-ID: <20071204224745.51e6c2b1@werewolf>
In-Reply-To: <20071203215727.543fc757@the-village.bc.nu>
References: <474EAD18.6040408@stellatravel.co.uk>
	<20071130143445.GA2310@csclub.uwaterloo.ca>
	<53ADBDBF-9B65-441E-B867-D68DE48ABD64@mac.com>
	<4751BE0D.3050609@argo.co.il>
	<p733aukyl8n.fsf@bingen.suse.de>
	<47539030.10600@argo.co.il>
	<20071203095022.GA28560@one.firstfloor.org>
	<4753ECA5.2010604@argo.co.il>
	<20071203211353.GA4009@1wt.eu>
	<20071203223902.1194aa69@werewolf>
	<20071203215727.543fc757@the-village.bc.nu>
X-Mailer: Claws Mail 3.1.0cvs49 (GTK+ 2.12.2; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Dec 2007 21:57:27 +0000, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > You could write an equally effcient kernel in languages like C++,
> > using C++ abstractions as a high level organization, where
> 
> It's very very hard to generate good C code because of the numerous ways
> objects get temporarily created, and the week aliasing rules (as with C).
> 

That is what I like of C++, with good placement of high level features
like const's and & (references) one can gain fine control over what
gets copied or not.
Try to write a Vector class that does ops with SSE without storing
temporals on the stack. Its a good example of how one can get low
level control, and gcc is pretty good simplifying things like u=v+2*w
and not putting anything on the stack, all in xmm registers.

The advantage is you onle has to be careful one time, when you write
the class.

> There are reasons that Fortran lives on (and no I'm not suggesting one
> should rewrite the kernel in Fortran ;)) and the fact its not really got
> pointer aliasing or "address of" operators and all the resulting
> optimsation problems is one of the big ones.
> 


--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.1 (Cooker) for i586
Linux 2.6.23-jam03 (gcc 4.2.2 (4.2.2-1mdv2008.1)) SMP Sat Nov
