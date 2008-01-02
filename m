Return-Path: <linux-kernel-owner+w=401wt.eu-S1759191AbYABNgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759191AbYABNgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 08:36:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754947AbYABNgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 08:36:41 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45888 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754925AbYABNgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 08:36:40 -0500
Date: Wed, 2 Jan 2008 13:26:21 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, trem <tremyfr@yahoo.fr>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc6-mm1
Message-ID: <20080102132621.4da29e29@the-village.bc.nu>
In-Reply-To: <20080102121909.GA6285@elte.hu>
References: <9DtBq-2jD-3@gated-at.bofh.it>
	<200801022131.15482.nickpiggin@yahoo.com.au>
	<1199271676.6821.112.camel@twins>
	<200801022212.29303.nickpiggin@yahoo.com.au>
	<1199273047.6821.119.camel@twins>
	<20080102121909.GA6285@elte.hu>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> BKL properties, that could be wrapped. I guess fixing the TTY code to 
> have no BKL dependencies has a higher chance of success - given that 
> Alan is working on it :-)

Bit by bit when I can face it, and with a lot of other people
contributing parts. Right now the BKL mostly protects the open/close
paths and those are *really* ugly
