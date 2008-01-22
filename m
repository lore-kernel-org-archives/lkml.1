Return-Path: <linux-kernel-owner+w=401wt.eu-S1759855AbYAVADV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759855AbYAVADV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 19:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbYAVADO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 19:03:14 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57476 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752862AbYAVADO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 19:03:14 -0500
Date: Tue, 22 Jan 2008 00:00:34 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: jeff@garzik.org, akpm@osdl.org, torvalds@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_pdc202xx_old: Fix crashes with ATAPI
Message-ID: <20080122000034.3e3f6dbb@lxorguk.ukuu.org.uk>
In-Reply-To: <200801220013.53545.bzolnier@gmail.com>
References: <20080119155126.180a010d@lxorguk.ukuu.org.uk>
	<200801220013.53545.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> IDE pdc202xx_old host driver supports ATAPI DMA just fine and in line
> with the PDC2026x programming guide.

News to me. It didn't last time I tried it the driver selected PIO.

> > So turn it ATAPI DMA off, these are disk optimised controllers.
> 
> This is an acceptable workaround for 2.6.24 but it probably just hides
> some deeper pata_pdc202xx_old or/and libata problem.

Hard to be sure. No docs here for the older ones.

Alan
