Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513AbYH0Ivk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbYH0Ivk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 04:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbYH0Iva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 04:51:30 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47471 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753067AbYH0Iv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 04:51:29 -0400
Date: Wed, 27 Aug 2008 09:32:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Parag Warudkar" <parag.lkml@gmail.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Adrian Bunk" <bunk@stusta.de>, "Rusty Russell" <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       "Ingo Molnar" <mingo@elte.hu>, linux-embedded@vger.kernel.org
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
 bisected
Message-ID: <20080827093251.41b6b3eb@lxorguk.ukuu.org.uk>
In-Reply-To: <f7848160808261936m18c69dc0r26f41850efae4b91@mail.gmail.com>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
	<alpine.LFD.1.10.0808261019450.3363@nehalem.linux-foundation.org>
	<20080826183051.GB10925@cs181140183.pp.htv.fi>
	<alpine.LFD.1.10.0808261144510.3363@nehalem.linux-foundation.org>
	<20080826205916.GB11734@cs181140183.pp.htv.fi>
	<alpine.LFD.1.10.0808261403360.3363@nehalem.linux-foundation.org>
	<f7848160808261554j2f4eaaa6i1ee8801ae75ca7bf@mail.gmail.com>
	<alpine.LFD.1.10.0808261644260.3363@nehalem.linux-foundation.org>
	<f7848160808261758q7b84aab1m188c1ebb59304818@mail.gmail.com>
	<alpine.LFD.1.10.0808261837530.3363@nehalem.linux-foundation.org>
	<f7848160808261936m18c69dc0r26f41850efae4b91@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What about deep call chains? The problem with the uptake of 4K stacks
> seems to be that is not reliably provable that it will work under all
> circumstances.

On x86-32 with 8K stacks your IRQ paths share them so that is even harder
to prove (not that you can prove any of them) and the bugs are more
obscure and random.
