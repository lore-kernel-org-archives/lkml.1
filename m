Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbXIBTMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbXIBTMV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 15:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbXIBTMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 15:12:14 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55098 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751001AbXIBTMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 15:12:14 -0400
Date: Sun, 2 Sep 2007 20:20:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Laurent Riffard <laurent.riffard@free.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc4-mm1: broke pata_via cable detection
Message-ID: <20070902202043.30976572@the-village.bc.nu>
In-Reply-To: <46DB088C.6080907@free.fr>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
	<46DB088C.6080907@free.fr>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> via_do_set_mode overwrites 80-wire cable detection bits. Let's
> preserve them.

Agreed, on a reset case we may otherwise get confused and misdetect the
cable. Change agrees with the data sheet


> 
> Signed-off-by: Laurent Riffard <laurent.riffard@free.fr>

Acked-by: Alan Cox <alan@redhat.com>

Thanks a lot
