Return-Path: <linux-kernel-owner+w=401wt.eu-S1763237AbYDXPet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763237AbYDXPet (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755743AbYDXPee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:34:34 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39528 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755499AbYDXPec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:34:32 -0400
Date: Thu, 24 Apr 2008 16:03:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] alternative to sys_indirect, part 1
Message-ID: <20080424160352.30f2dd5b@the-village.bc.nu>
In-Reply-To: <4810A46B.1090809@redhat.com>
References: <200804240403.m3O43us8028699@devserv.devel.redhat.com>
	<20080424112514.055d8071@the-village.bc.nu>
	<481096C3.2020206@redhat.com>
	<20080424152436.6cf53c1b@the-village.bc.nu>
	<4810A46B.1090809@redhat.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You didn't read what I wrote.

The feeling is mutual

> For those the implementer must ensure that during the development no
> value is used which can conflict with any current and future assigned
> value and not with any other development.

Kernel socket type values are assigned by the kernel team so that
isn't a problem.

> > Every other property of a socket via accept() is inherited from the
> > parent. Making one property different would be bizarre and ugly.
> 
> Implementing this would visibly change existing code and it would
> actively violate POSIX.  Not a good idea.

POSIX has no interface for this new behaviour you propose so that is
complete crap. The moment you use one of these features you stepped
outside of the POSIX spec - and you know that. If there was an existing
standard we wouldn't have a problem.

Alan
