Return-Path: <linux-kernel-owner+w=401wt.eu-S1755880AbYBEMdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbYBEMdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 07:33:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbYBEMdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 07:33:35 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35034 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752138AbYBEMde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 07:33:34 -0500
Date: Tue, 5 Feb 2008 12:27:41 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Newall <davidn@davidnewall.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
       David Newall <davidn@davidnewall.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Christer Weinigel <christer@weinigel.se>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Message-ID: <20080205122741.24b8a392@core>
In-Reply-To: <courier.47A84ADB.000047C1@hawking.rebel.net.au>
References: <20080125180232.GA4613@kroah.com>
	<20080202123710.42df1aa0@weinigel.se>
	<20080202191930.GA19826@kroah.com>
	<47A5D9CD.5070001@davidnewall.com>
	<84144f020802030743j1278ac64j2ee3e2cbc5c3fefc@mail.gmail.com>
	<47A5E67D.9040804@davidnewall.com>
	<1202058820.15090.60.camel@violet>
	<courier.47A84ADB.000047C1@hawking.rebel.net.au>
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

> It is precisely the fact that it is a loadable module, and does not form 
> part of the kernel, that removes the requirement to distribute it under GPL. 

That would be your own personal strange opinion.

Having actually spent time with lawyers on the subject the question that
matters for the GPL is the line between a derivative work and a
non-derivative work. The former the GPL covers - the latter it does not.
That is totally independent of the technical implementation of the
loading and combining of the code.

There is even at least one case where the lawyers on both sides of a
dispute have concurred that something is derivative because it was closely
dependant on a backend that it communicated with by pipes and was useless
without that backend and clearly built solely to use it.

Mechanism is not important, whether you are doing RPC calls, dynamic
linking or static linking isn't part of the creative process.

The only exception to the derivative work question is usual system calls.
I don't think anyone expects those to create a derivative work anyway but
just in case the law gets a bit carried away the COPYING file for the
kernel explicitly covers this to ensure there is certainty about running
totally seperate proprietary applications on the Linux kernel.

Alan
