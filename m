Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbYIOQyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbYIOQyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 12:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753811AbYIOQxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 12:53:54 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:37452 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbYIOQxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 12:53:54 -0400
Date: Mon, 15 Sep 2008 17:22:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Fortescue <mark@mtfhpc.demon.co.uk>
Cc: David Miller <davem@davemloft.net>, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
       joy@entuzijast.net
Subject: Re: Allow 8250 to work on sparc.
Message-ID: <20080915172211.6751bb17@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.61.0809151507250.23201@mtfhpc.demon.co.uk>
References: <20080912.211854.102505246.davem@davemloft.net>
	<Pine.LNX.4.61.0809151507250.23201@mtfhpc.demon.co.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> At the user level, there is no difference between a sun zilog serial port, 
> an 8250 serial port or a USB serial port so these should be allocated 
> using the same allocation system.

That isn't strictly true.

> For me, it would also simplify the issue of trying to work what devive to 
> look for when I plug in a new USB serial port device. It would be the new 
> /dev/ttyS<x> to appear in /dev.

Naming is a private matter for udev anyway, independant of numbering for
major/minor
