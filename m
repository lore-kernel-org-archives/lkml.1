Return-Path: <linux-kernel-owner+w=401wt.eu-S937177AbXFGVue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937177AbXFGVue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 17:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934867AbXFGVu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 17:50:27 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41950 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761191AbXFGVu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 17:50:26 -0400
Date: Thu, 7 Jun 2007 22:55:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, paulus@samba.org
Subject: Re: [SERIAL] Don't optimise away baud rate changes when BOTHER is
 used
Message-ID: <20070607225528.0d5e7b29@the-village.bc.nu>
In-Reply-To: <1181231421.2785.68.camel@pmac.infradead.org>
References: <20070523172739.1d3a918c@the-village.bc.nu>
	<1180012135.8303.89.camel@shinybook.infradead.org>
	<20070524144109.7bd0f4d0@the-village.bc.nu>
	<1180014338.8303.95.camel@shinybook.infradead.org>
	<20070524160559.54c2c639@the-village.bc.nu>
	<1181133010.4096.26.camel@pmac.infradead.org>
	<20070606160310.27d6d3b8@the-village.bc.nu>
	<1181150998.2785.13.camel@pmac.infradead.org>
	<20070607163808.19984208@the-village.bc.nu>
	<1181231421.2785.68.camel@pmac.infradead.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Jun 2007 16:50:21 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> On Thu, 2007-06-07 at 16:38 +0100, Alan Cox wrote:
> > If your termios and termios2 structures differ in size then you need to
> > copy the right number of bytes or you won't get speed values into the
> > kernel. If they are the same size it wont matter.
> 
> +/* Yay. A third identical definition of the same structure. */
> +struct termios2 {


Umm if your struct termios has the c_ispeed/c_ospeed fields then you
don't need to add the new ioctls to the PPC either - the Alpha is the
same here. 

Alan
