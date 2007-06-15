Return-Path: <linux-kernel-owner+w=401wt.eu-S1751144AbXFOPJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751144AbXFOPJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 11:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755561AbXFOPJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 11:09:30 -0400
Received: from mail.lmcg.wisc.edu ([144.92.101.145]:48071 "EHLO
	mail.lmcg.wisc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366AbXFOPJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 11:09:28 -0400
Date: Fri, 15 Jun 2007 10:09:15 -0500
From: Daniel Forrest <forrest@lmcg.wisc.edu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Bernd Paysan <bernd.paysan@gmx.de>, Alexandre Oliva <aoliva@redhat.com>,
       Paulo Marques <pmarques@grupopie.com>, Al Viro <viro@ftp.linux.org.uk>,
       Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070615100915.A24218@yoda.lmcg.wisc.edu>
Reply-To: Daniel Forrest <forrest@lmcg.wisc.edu>
References: <466A3EC6.6030706@netone.net.tr> <or4plae61r.fsf@oliva.athome.lsd.ic.unicamp.br> <d120d5000706141155s4e9caceci6958ceceebad6c73@mail.gmail.com> <200706151048.57762.bernd.paysan@gmx.de> <d120d5000706150546k6a31f831tb496bc73bbaa553@mail.gmail.com> <20070615135739.14862d6d@the-village.bc.nu> <d120d5000706150603w2f70431ei5a2ae461ac3d0ff4@mail.gmail.com> <20070615141923.63fd5cdd@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5.1i
In-Reply-To: <20070615141923.63fd5cdd@the-village.bc.nu>; from alan@lxorguk.ukuu.org.uk on Fri, Jun 15, 2007 at 02:19:23PM +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2007 at 02:19:23PM +0100, Alan Cox wrote:
> 
> > GPL itself does not. But the author(s) may when they specify "any
> > later version", "dual GPL/BSD", etc. In this case (IMHO) distributor
> > in fact relicenses the code and may reduce license to sipmply BSD or
> > simply GPL, or "GPL v3 from now on". To "restore" license you would
> > need to go upstream and get the code from there.
> > 
> I don't see anything in the GPL that permits a redistributor to
> change the licence a piece of code is distributed under. If my code
> is GPL v2 or later you cannot take away the "or later" unless
> explicitly granted powers by the author to vary the licence.
> 
> What you most certainly can do is modify it and decide your
> modifications are GPLv3 only thus creating a derived work which is
> GPLv3 only. However anyone receiving your modified version and
> reverting the modifications is back at v2 or later.

But that begs the question: How do you know what has been modified so
you can revert the modifications?  There won't necessarily be any
indication of which files have been modified.

So I think Dmitry's point is valid.  Don't you need to go upstream at
least far enough to verify that you have unmodified code?

And how does the copyright work for kernel patches?  Consider a dual
licensed (i.e. anything beyond GPLv2 only) file.  Someone supplies
patches to Linus, he applies them, the resulting file is distributed
with the kernel as GPLv2.  What precisely has to happen for someone
to get that same file with equivalent patches applied that can be
distributed with the original dual license?

Somehow it seems to me that Linus would have to take the dual licensed
files from his kernel repository and copy them to a separate archive
and people would have to copy from there to keep the dual license.
Aren't the files you extract from a linux tarball only licensed to you
under the terms of GPLv2?

-- 
Dan
