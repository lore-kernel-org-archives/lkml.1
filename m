Return-Path: <linux-kernel-owner+w=401wt.eu-S1764273AbYBNTpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764273AbYBNTpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 14:45:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757550AbYBNTpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 14:45:20 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45188 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758199AbYBNTpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 14:45:19 -0500
Date: Thu, 14 Feb 2008 19:37:31 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: David Newall <davidn@davidnewall.com>, Greg KH <greg@kroah.com>,
       linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Handshaking on USB serial devices
Message-ID: <20080214193731.3c36acb0@core>
In-Reply-To: <200802141255.22048.gene.heskett@gmail.com>
References: <47B30291.2040905@davidnewall.com>
	<200802141116.14722.gene.heskett@gmail.com>
	<20080214163143.0915b44c@core>
	<200802141255.22048.gene.heskett@gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> byte of a packet is being thrown away about .1% of the time for the pl2303, 
> but I'm not sure if the FTDI driver still suffers from a similar rash.  I 

A 20 byte low speed message is too small for flow control to account for
it.
