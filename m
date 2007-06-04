Return-Path: <linux-kernel-owner+w=401wt.eu-S1756166AbXFDNof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbXFDNof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 09:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbXFDNoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 09:44:12 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40597 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752391AbXFDNoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 09:44:11 -0400
Date: Mon, 4 Jun 2007 14:49:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Aaron Wiebe" <epiphani@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: slow open() calls and o_nonblock
Message-ID: <20070604144918.42354235@the-village.bc.nu>
In-Reply-To: <e7ca40f70706031152q4e9630aq3c29623bd56fe0e5@mail.gmail.com>
References: <e7ca40f70706031152q4e9630aq3c29623bd56fe0e5@mail.gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Now, I'm a userspace guy so I can be pretty dense, but shouldn't a
> call with a nonblocking flag return EAGAIN if its going to take
> anywhere near 415ms?  

Violation of causality. We don't know it will block for 415ms until 415ms
have elapsed. 

Alan
