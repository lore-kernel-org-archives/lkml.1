Return-Path: <linux-kernel-owner+w=401wt.eu-S1760666AbYDTLbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760666AbYDTLbg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 07:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758830AbYDTLb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 07:31:27 -0400
Received: from port-212-202-105-50.static.qsc.de ([212.202.105.50]:58244 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758315AbYDTLbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 07:31:25 -0400
Date: Sun, 20 Apr 2008 12:02:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080420120250.4f496861@the-village.bc.nu>
In-Reply-To: <20080420104444.GI1595@cs181133002.pp.htv.fi>
References: <200804181737.m3IHbabI010051@hera.kernel.org>
	<20080418142934.38ce6bf4.akpm@linux-foundation.org>
	<20080419142329.GA5339@elte.hu>
	<20080419145948.GA4528@lintop>
	<20080420080901.GF1595@cs181133002.pp.htv.fi>
	<20080420090623.7b173ef1@the-village.bc.nu>
	<20080420085104.GG1595@cs181133002.pp.htv.fi>
	<20080420103611.2c0d3519@the-village.bc.nu>
	<20080420104444.GI1595@cs181133002.pp.htv.fi>
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

> The code in the kernel that gets the fewest coverage at all are our 
> error paths, and some vendor might try 4k stacks, validate it works in 
> all use cases - and then it will blow up in some error condition he 
> didn't test.

Which you won't fix by changing the x86 defaults. More of a problem in
embedded small devices is the 8K allocation failing in the first place -
plus 4K x 80 processes == lots.

> And from a QA point of view the only way of getting 4k thoroughly tested 
> by users, and well also tested in -rc kernels for catching regressions 
> before they get into stable kernels, is if we get 4k stacks enabled 
> unconditionally on i386.

At which point some distros will simply patch it back no doubt.
