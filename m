Return-Path: <linux-kernel-owner+w=401wt.eu-S1763636AbYDOKPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763636AbYDOKPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 06:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756212AbYDOKPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 06:15:44 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46986 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753871AbYDOKPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 06:15:43 -0400
Date: Tue, 15 Apr 2008 11:11:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, alan@redhat.com, borntraeger@de.ibm.com,
       peter.oberparleiter@de.ibm.com, schwidefsky@de.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: + s390-tty-prepare-for-put_char-to-return-success-fail.patch
 added to -mm tree
Message-ID: <20080415111101.41b6e9e3@core>
In-Reply-To: <20080415072117.GA4177@osiris.boeblingen.de.ibm.com>
References: <200804150204.m3F24GdU005600@imap1.linux-foundation.org>
	<20080415072117.GA4177@osiris.boeblingen.de.ibm.com>
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

> is allowed or not (1 means yes). Somebody told me that the put_char routine
> will only be called from schedulable context, which now doesn't seem to be
> true?!

It isnt true.

> For the console functions we pass indeed 0 to __sclp_vt220_write since printk
> may be called within any context. Is that also true for the tty put_char
> routine?

Yes, but failing a put_char is perfectly acceptable.

Alan
