Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903AbYFIOOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbYFIOOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 10:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbYFIOOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 10:14:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54457 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751090AbYFIOON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 10:14:13 -0400
Date: Mon, 9 Jun 2008 14:57:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Will C <willjcroz@yahoo.co.uk>
Cc: linux-kernel@vger.kernel.org, yorgasor@gmail.com
Subject: Re: Better support for Delkin cardbus CF adapters -- IDE layer
Message-ID: <20080609145749.677425a9@core>
In-Reply-To: <300869.94850.qm@web26005.mail.ukl.yahoo.com>
References: <300869.94850.qm@web26005.mail.ukl.yahoo.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> http://66.102.9.104/translate_c?hl=en&sl=ja&u=http://www.workbit.co.jp/products/utata.html
> 
> The contact form does not translate correctly and so it seems someone fluent in Japanese would be the best bet to approach Workbit for documentation/specification.

Japanese people have tried. ITOH Yasafumi one of the BSD folks has done
some very significant reverse engineering work on the Delkin and friends
to get PIO mode working properly. Our libata driver is basically built on
that work.

> I have a brand new spare card here (with a Delkin 2GB 305x speed CF card in it) and am willing to send it to a kernel developer interested in working on a driver for it (Mark Lord?). Alternatively if anyone wants me to dump registers under Windows, test drivers etc I am prepared to put in the time to help in these ways. 

The current state of affairs is the libata pata_ninja32 driver. That
should give good PIO performance. If you want DMA I think you'll have to
do it yourself however, or hope the BSD folks get it working reliably.

