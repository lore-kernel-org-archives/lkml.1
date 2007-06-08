Return-Path: <linux-kernel-owner+w=401wt.eu-S970440AbXFHQVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970440AbXFHQVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970005AbXFHQTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:19:14 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57007 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S970362AbXFHQTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:19:10 -0400
Date: Fri, 8 Jun 2007 17:24:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Include <asm/termbits.h> from <linux/tty_driver.h>.
Message-ID: <20070608172422.55f3db5f@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.64.0706081211280.1504@localhost.localdomain>
References: <Pine.LNX.4.64.0706080925020.24228@localhost.localdomain>
	<20070608163018.636b74d1@the-village.bc.nu>
	<Pine.LNX.4.64.0706081125390.30491@localhost.localdomain>
	<20070608164830.54436f6b@the-village.bc.nu>
	<Pine.LNX.4.64.0706081144300.31863@localhost.localdomain>
	<20070608165746.30fb5bd9@the-village.bc.nu>
	<Pine.LNX.4.64.0706081211280.1504@localhost.localdomain>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> if you don't agree with that patch, fine.  but suggesting that it's
> going to result in "a mass of unresolvable dependancy loops" is sheer
> laziness.

No its "sheer experience", frequently painful. The tty headers and the
scheduler headers are particularly problematic for getting tangled.

Alan
