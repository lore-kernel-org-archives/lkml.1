Return-Path: <linux-kernel-owner+w=401wt.eu-S1757820AbYDTKF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820AbYDTKF0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbYDTKFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:05:13 -0400
Received: from port-212-202-105-50.static.qsc.de ([212.202.105.50]:53117 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752542AbYDTKFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:05:11 -0400
Date: Sun, 20 Apr 2008 10:36:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080420103611.2c0d3519@the-village.bc.nu>
In-Reply-To: <20080420085104.GG1595@cs181133002.pp.htv.fi>
References: <200804181737.m3IHbabI010051@hera.kernel.org>
	<20080418142934.38ce6bf4.akpm@linux-foundation.org>
	<20080419142329.GA5339@elte.hu>
	<20080419145948.GA4528@lintop>
	<20080420080901.GF1595@cs181133002.pp.htv.fi>
	<20080420090623.7b173ef1@the-village.bc.nu>
	<20080420085104.GG1595@cs181133002.pp.htv.fi>
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

On Sun, 20 Apr 2008 11:51:04 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> On Sun, Apr 20, 2008 at 09:06:23AM +0100, Alan Cox wrote:
> > > The stack problems in the kernel tend to not be in arch code, and if 
> > > we don't get i386 to always run with 4k stacks there's no chance that 
> > > it will ever work reliably on other architectures.
> > 
> > Not really the case - embedded tends not to use deep stacks of drivers.
> 
> Something like nfsd-over-xfs-over-raid is (or was) the most common 
> problem - and this or similar stackings might be used in NAS devices.

Specific cases yes, but such NAS devices have big processors and are not
little emdedded CPUs. On an embedded box you know at build time what it
will be doing.
