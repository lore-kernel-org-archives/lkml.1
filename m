Return-Path: <linux-kernel-owner+w=401wt.eu-S1759918AbYAVBjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759918AbYAVBjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 20:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754910AbYAVBjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 20:39:14 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50711 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754702AbYAVBjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 20:39:13 -0500
Date: Tue, 22 Jan 2008 01:36:30 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: jeff@garzik.org, akpm@osdl.org, torvalds@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_pdc202xx_old: Fix crashes with ATAPI
Message-ID: <20080122013630.736c973e@lxorguk.ukuu.org.uk>
In-Reply-To: <200801220225.10168.bzolnier@gmail.com>
References: <20080119155126.180a010d@lxorguk.ukuu.org.uk>
	<200801220013.53545.bzolnier@gmail.com>
	<20080122000034.3e3f6dbb@lxorguk.ukuu.org.uk>
	<200801220225.10168.bzolnier@gmail.com>
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

> Are you by any chance using PDC20263?
> 
> [ PDC2026{5,7} should be fine (unless somebody broke it but then git-bisect
>   should do the job)... ]

I tried both the 20263 and 20267. The logs I've got from the older trees
all show PIO in use. I'll dig further when I get time.


Alan
