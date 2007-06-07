Return-Path: <linux-kernel-owner+w=401wt.eu-S1755615AbXFGLXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615AbXFGLXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 07:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751626AbXFGLXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 07:23:16 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47729 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751510AbXFGLXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 07:23:16 -0400
Date: Thu, 7 Jun 2007 12:27:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Message-ID: <20070607122746.46f226fe@the-village.bc.nu>
In-Reply-To: <20070607124505.2d829b9b.dada1@cosmosbay.com>
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7>
	<20070606235906.72439d16@the-village.bc.nu>
	<Pine.LNX.4.64.0706061558550.10383@alien.or.mcafeemobile.com>
	<20070607001932.35c9591c@the-village.bc.nu>
	<Pine.LNX.4.64.0706061619560.10383@alien.or.mcafeemobile.com>
	<20070607110623.53322dae@the-village.bc.nu>
	<20070607124505.2d829b9b.dada1@cosmosbay.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Alan, prctl() things are usually inherited at fork()/exec() time.

You want them inherited at fork time.

> If you fork() from a new application , then exec an old one 
> (eventually a statically linked program), we have a problem ?

Only if you decide not to reset the value. There are lots of things we do
inherit and lots we don't.

Alan
