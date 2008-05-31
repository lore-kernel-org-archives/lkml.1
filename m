Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988AbYEaOUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbYEaOUS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 10:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbYEaOUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 10:20:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39656 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752552AbYEaOUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 10:20:03 -0400
Date: Sat, 31 May 2008 15:05:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Jeff Garzik <jeff@garzik.org>,
       David Woodhouse <dwmw2@infradead.org>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, James.Bottomley@hansenpartnership.com,
       David Miller <davem@davemloft.net>
Subject: Re: [Ksummit-2008-discuss] RFC: Moving firmware blobs out of the
 kernel.
Message-ID: <20080531150526.46cda105@core>
In-Reply-To: <48408A67.4090006@zytor.com>
References: <1211995212.3445.52.camel@localhost.localdomain>
	<20080528.225826.40264516.davem@davemloft.net>
	<1212041839.8888.38.camel@pasglop>
	<20080529124548.GC8065@mit.edu>
	<1212077700.26088.83.camel@shinybook.infradead.org>
	<483F002E.5060002@garzik.org>
	<1212095864.24826.2.camel@lappy.programming.kicks-ass.net>
	<483F3EC4.5050700@zytor.com>
	<20080530103107.4f71cfe3@core>
	<48408A67.4090006@zytor.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (*) Not saying that a klibc-based initramfs is necessarily smaller than 
> the in-kernel code it replaces, but the total size is << than the size 
> of the kernel proper, which isn't true when using a full-featured libc.

True but with a vendor hat on thats not usually a problem on modern
systems and using glibc means less code to maintain, less special cases,
and more flexibility.

For embedded klibc may well be interesting.

Alan
