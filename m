Return-Path: <linux-kernel-owner+w=401wt.eu-S1755848AbXKVB6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbXKVB6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 20:58:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753576AbXKVB6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 20:58:41 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42109 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753383AbXKVB6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 20:58:41 -0500
Date: Thu, 22 Nov 2007 01:56:25 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Al Niessner <Al.Niessner@jpl.nasa.gov>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Where is the interrupt going?
Message-ID: <20071122015625.0e33acfc@the-village.bc.nu>
In-Reply-To: <1195693710.5544.240.camel@morte.jpl.nasa.gov>
References: <1195693710.5544.240.camel@morte.jpl.nasa.gov>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> status = request_irq (apcsi[i].board_irq,
>                                       apc8620_handler,
>                                       IRQF_DISABLED,

You set IRQF_DISABLED

Do you then enable the interrupt anywhere later on ?

Alan
