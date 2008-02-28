Return-Path: <linux-kernel-owner+w=401wt.eu-S1759260AbYB1L1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260AbYB1L1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 06:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756890AbYB1L1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 06:27:36 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56221 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756749AbYB1L1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 06:27:35 -0500
Date: Thu, 28 Feb 2008 11:15:10 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: Linux 2.6.25-rc2
Message-ID: <20080228111510.11f9e391@core>
In-Reply-To: <20080228081412.GE28781@elte.hu>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org>
	<64bb37e0802161338j306c1357m25bc224f09e6b7cd@mail.gmail.com>
	<20080219061107.GA23229@elte.hu>
	<64bb37e0802182254l49b10cbblc23f8a83d189ff8e@mail.gmail.com>
	<84144f020802182321x452888bai639c71ea2a5067da@mail.gmail.com>
	<20080219140230.GA32236@Krystal>
	<84144f020802190621s509dbe7gc8e5609d94aca9b4@mail.gmail.com>
	<20080219200852.GC11197@Krystal>
	<Pine.LNX.4.64.0802271532220.14380@schroedinger.engr.sgi.com>
	<20080227175726.ad6bda9d.akpm@linux-foundation.org>
	<20080228081412.GE28781@elte.hu>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> hm, why should it be atomic wrt. irqs? There's nothing that keeps gcc 

It isn't - we've got tty layer traces of serial counts going wrong that
rely on precisely that assumption.

Alan
