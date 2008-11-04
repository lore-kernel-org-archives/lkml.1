Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbYKDUgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbYKDUgv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 15:36:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbYKDUgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 15:36:42 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57159 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753698AbYKDUgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 15:36:41 -0500
Date: Tue, 4 Nov 2008 20:36:43 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Chris Friesen" <cfriesen@nortel.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [BUG] serial base baud misdetected in 2.6.27
Message-ID: <20081104203643.77cdfa6c@lxorguk.ukuu.org.uk>
In-Reply-To: <4910B0AD.3020802@nortel.com>
References: <4910936D.4030605@nortel.com>
	<20081104192253.151d6ef3@lxorguk.ukuu.org.uk>
	<4910B0AD.3020802@nortel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> like it's hanging off the PCI bus.  The vendor/device matches to an Exar 
> Corp. XR17C152, which is given a base_baud of 921600 in 
> drivers/serial/8250_pci.c.
> 
> According to the chip specs, 921600 is correct with the default crystal 
> and control register values.  However, other crystals can be used and 
> there's also a control register bit to enable a prescalar which cuts the 
> baud rate by a factor of four.  I suspect that one of these has been 
> done on our boards.

Probably. Did your vendor have the sense to set subvendor/subdevice
identifiers that can be used to identify that specific unit ?

