Return-Path: <linux-kernel-owner+w=401wt.eu-S1760678AbYFDMDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760678AbYFDMDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 08:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754392AbYFDMDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 08:03:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55954 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750764AbYFDMDC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 08:03:02 -0400
Date: Wed, 4 Jun 2008 12:47:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Trent Piepho <tpiepho@freescale.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: MMIO and gcc re-ordering issue
Message-ID: <20080604124714.55dbce65@core>
In-Reply-To: <alpine.LFD.1.10.0806031932370.3473@woody.linux-foundation.org>
References: <1211852026.3286.36.camel@pasglop>
	<Pine.LNX.4.64.0806031130130.3242@t2.domain.actdsltmp>
	<alpine.LFD.1.10.0806031153360.3473@woody.linux-foundation.org>
	<200806041205.45833.nickpiggin@yahoo.com.au>
	<alpine.LFD.1.10.0806031932370.3473@woody.linux-foundation.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Anyway, Intel certainly seems to document that WC memory is serialized by 
> any access to UC memory.

I don't believe that is actually true on Pentium Pro at least.

>   So what started out as a "we can do accesses to the frame buffer more 
>   efficiently without anybody ever even having to know or care" has 
>   turned into a whole nightmare of people using it for other things, and 
>   then you very much _do_ have to care! ]

Notably graphics where 3Dfx lined the registers up specifically to make
this work. We were also using it with I²O where it gave a small
performance gain.

Alan
