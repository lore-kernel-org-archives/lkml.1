Return-Path: <linux-kernel-owner+w=401wt.eu-S1760543AbYALVpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760543AbYALVpT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 16:45:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757630AbYALVpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 16:45:05 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37108 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756023AbYALVpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 16:45:03 -0500
Date: Sat, 12 Jan 2008 21:42:30 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>, akpm@osdl.org,
       linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: remove "too much work for irq" printk
Message-ID: <20080112214230.241018d4@lxorguk.ukuu.org.uk>
In-Reply-To: <47893374.4080102@zytor.com>
References: <20080112201543.GB12775@kvack.org>
	<20080112212457.3bf534af@lxorguk.ukuu.org.uk>
	<47893374.4080102@zytor.com>
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

> This is going to put trouble in other places unless, at least, it can be 
> turned off.  The UART serial interface is heavily emulated as a console 
> interface without an actual serial port behind it, both in hardware and 
> software.  Rates will typically vastly exceed real serial port rates, 

Yes Dell do it, HP do it, IBM do it. Have done for years, never caused us
a problem. Its only KVM tripping it.

As to bit rate we support up to about 1 to 1.5 Mbit.

Alan
