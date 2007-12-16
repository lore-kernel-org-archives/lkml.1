Return-Path: <linux-kernel-owner+w=401wt.eu-S1759562AbXLPUZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759562AbXLPUZd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 15:25:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755848AbXLPUZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 15:25:26 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59049 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753659AbXLPUZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 15:25:25 -0500
Date: Sun, 16 Dec 2007 20:18:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Parag Warudkar" <parag.warudkar@gmail.com>
Cc: devzero@web.de, Matt.Domsch@dell.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] be more verbose when probing EDD
Message-ID: <20071216201849.24f7aa5f@the-village.bc.nu>
In-Reply-To: <82e4877d0712161159r2572dbbfi15159c66e4b7e33b@mail.gmail.com>
References: <49448787@web.de>
	<82e4877d0712161159r2572dbbfi15159c66e4b7e33b@mail.gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why tax other people with a warning/hang etc. in printk when the
> problem is very unlikely on their systems?

I think there is sense in it if you do it subtly differently.

	printk(".. if this hangs do ... \r");
	edd_stuff();
	printk("                          \r");
	

So that we display it, do the EDD call, then write over it with whatever
is next that matters.

That way you'd only see it when it hung - and that might be worth a patch
and test from someone.
