Return-Path: <linux-kernel-owner+w=401wt.eu-S1753656AbXJVQrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbXJVQrq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 12:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbXJVQri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 12:47:38 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59053 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751553AbXJVQrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 12:47:37 -0400
Date: Mon, 22 Oct 2007 17:50:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Crispin Cowan <crispin@crispincowan.com>
Cc: Thomas Fricaccia <thomas_fricacci@yahoo.com>, linux-kernel@vger.kernel.org,
       LSM ML <linux-security-module@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: LSM conversion to static interface
Message-ID: <20071022175043.0aa65957@the-village.bc.nu>
In-Reply-To: <471CCB77.3040004@crispincowan.com>
References: <200710220224.l9M2Og5t020815@sapphire.spiritone.com>
	<20071022110718.3f781108@the-village.bc.nu>
	<471CCB77.3040004@crispincowan.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Crispin at least is providing genuine discussion points. Sarbox has
> > nothing to say on "using vendor linux kernels".
> >   
> I agree that SarBox is not really the issue here. Partially related is
> enterprise rules about what kernels one is allowed to load. More
> generally, this change forces users who want to use a different LSM than
> their vendor provides to recompile their kernel, where they did not have
> to recompile before. It forces LSM module developers who want to modify
> their LSM to reboot, where they didn't necessarily have to reboot before.

The moment they load a module from a third party they usually hit support
issues, unless there is some kind of arrangement between the parties.

> 
> That is not a catastrophe, it is just tedious. It does not kill baby
> seals, and it does not make Linux utterly useless. OTOH, I think it is
> strictly negative: it takes away user choice in 2 dimensions, and adds
> zero value. So apply it if you must to bake the kernel developer's lives
> easier, but it really is a net loss in Linux kernel capability.

Frankly I don't care about apparmor, I don't see it as a serious project.
Smack is kind of neat but looks like a nicer way to specify selinux rules.

What I do care about is that at some point something is going to appear
which is based on all the same good practice and experience and forty
years of research that leads towards SELinux, and which is much better. At
that point there will be a changeover phase and the LSM is exactly what
is needed for this.

The fact it allows people to play with toy security systems, propose new
ones like SMACK, and do research and PhD work on Linux into security is a
convenient and very good side effect.

For that reason I think keeping LSM is the right thing to do.

Alan
