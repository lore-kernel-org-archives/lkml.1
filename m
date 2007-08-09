Return-Path: <linux-kernel-owner+w=401wt.eu-S1760336AbXHIWrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760336AbXHIWrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 18:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbXHIWrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 18:47:42 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35019 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752209AbXHIWrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 18:47:40 -0400
Date: Thu, 9 Aug 2007 23:54:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_artop: fix UDMA5 for AEC6280[R] and UDMA6 for
 AEC6880[R]
Message-ID: <20070809235455.3117d5dc@the-village.bc.nu>
In-Reply-To: <200708092319.34828.bzolnier@gmail.com>
References: <200708092319.34828.bzolnier@gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2007 23:19:34 +0200
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> 
> Maximum supported UDMA mode for AEC6280[R] is UDMA5 (not UDMA4)
> and for AEC6880[R] it is UDMA6 (not UDMA5):
> 
> * Fix the problem by adding missing struct ata_port_info to artop_init_one().
> 
> * Use the right naming (s/626/628/).
> 
> * Bump driver version.
> 
> Fixes IDE->libata regression, problem was never present in IDE aec62xx driver.

Have you tested this ??

