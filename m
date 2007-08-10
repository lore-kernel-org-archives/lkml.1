Return-Path: <linux-kernel-owner+w=401wt.eu-S937978AbXHJNzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937978AbXHJNzR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 09:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765956AbXHJNy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 09:54:58 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37601 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762958AbXHJNy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 09:54:56 -0400
Date: Fri, 10 Aug 2007 15:01:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_artop: fix UDMA5 for AEC6280[R] and UDMA6 for
 AEC6880[R]
Message-ID: <20070810150157.3c1196b4@the-village.bc.nu>
In-Reply-To: <200708100145.38739.bzolnier@gmail.com>
References: <200708092319.34828.bzolnier@gmail.com>
	<20070809235455.3117d5dc@the-village.bc.nu>
	<200708100145.38739.bzolnier@gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> BTW presence of the above bugs would strongly indicate that pata_artop has
> never been tested (properly) with AEC6x80[R], otherwise these bugs should
> have been noticed and fixed much earlier.

People don't seem to notice minor speed limiting errors, and its a pretty
obscure controller too. Not suprised (it took ages for them to notice the
CMD64x one too).

It has however been tested and works pretty well for most cases. There's
one platform where you have to hack both drivers to make them work which
I need to investigate further.

