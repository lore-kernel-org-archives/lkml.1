Return-Path: <linux-kernel-owner+w=401wt.eu-S1756298AbYBXRSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298AbYBXRSN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 12:18:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbYBXRRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 12:17:54 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54756 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754501AbYBXRRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 12:17:34 -0500
Date: Sun, 24 Feb 2008 17:07:35 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata fixes
Message-ID: <20080224170735.7fed8ab6@core>
In-Reply-To: <200802241821.15052.bzolnier@gmail.com>
References: <20080224053508.GA17530@havoc.gtf.org>
	<200802241821.15052.bzolnier@gmail.com>
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

> From the patch description it can't be told whether the patch itself is
> correct and only the patch description is bogus...

zero length PRD misparsing. If I remember rightly old IDE never generates
64K PRD slots because other hardware can't handle it either (CS5520/30
etc)
