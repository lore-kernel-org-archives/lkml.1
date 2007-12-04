Return-Path: <linux-kernel-owner+w=401wt.eu-S1752486AbXLDX32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbXLDX32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 18:29:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750955AbXLDX3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 18:29:21 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33956 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750896AbXLDX3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 18:29:21 -0500
Date: Tue, 4 Dec 2007 23:24:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Jared Hulbert" <jaredeh@gmail.com>
Cc: "Chris Friesen" <cfriesen@nortel.com>, linux-kernel@vger.kernel.org
Subject: Re: solid state drive access and context switching
Message-ID: <20071204232449.6148e152@the-village.bc.nu>
In-Reply-To: <6934efce0712041354n47c11d6ckbc7f4aa1e7c85f@mail.gmail.com>
References: <47548BF4.3010907@nortel.com>
	<20071203230629.725f4c7a@the-village.bc.nu>
	<6934efce0712040954v74cf0b4bk19b49988bc828233@mail.gmail.com>
	<20071204203536.2bf6d025@the-village.bc.nu>
	<6934efce0712041354n47c11d6ckbc7f4aa1e7c85f@mail.gmail.com>
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

> Right.  The trend is to hide the nastiness of NAND technology changes
> behind controllers.  In general I think this is a good thing.

You miss the point - any controller you hide it behind almost inevitably
adds enough latency you don't want to use it synchronously.

Alan

