Return-Path: <linux-kernel-owner+w=401wt.eu-S936529AbZAPSW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936529AbZAPSW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 13:22:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761302AbZAPSVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 13:21:49 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55916 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S936651AbZAPSVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 13:21:48 -0500
Date: Fri, 16 Jan 2009 18:21:28 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata fixes
Message-ID: <20090116182128.35b63bf7@lxorguk.ukuu.org.uk>
In-Reply-To: <20090116093101.6d77b69b.akpm@linux-foundation.org>
References: <20090116152721.GA6994@havoc.gtf.org>
	<20090116093101.6d77b69b.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	for (i = 0; i < 2; i++)
> 
> s/2/ARRAY_SIZE/

It's 2. It's always 2 for a SFF controller. ARRAY_SIZE is just confusing
in this case as the array won't change size.


> There's a 64-bit divide in there.  Will it link on 32-bit platforms?
> Or is this all 64-bit-only code?
> 
> wtf is an octeon anyway?  (greps).  Some MIPS thing.  I guess it's
> 64-bit-only.

Board specific driver anyway

