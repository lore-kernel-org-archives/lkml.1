Return-Path: <linux-kernel-owner+w=401wt.eu-S937579AbXFGWtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937579AbXFGWtx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 18:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936640AbXFGWtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 18:49:45 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40674 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932857AbXFGWto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 18:49:44 -0400
Date: Thu, 7 Jun 2007 23:54:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, paulus@samba.org
Subject: Re: [SERIAL] Don't optimise away baud rate changes when BOTHER is
 used
Message-ID: <20070607235441.17dbd5cc@the-village.bc.nu>
In-Reply-To: <1181254517.20322.6.camel@shinybook.infradead.org>
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
	<20070607225528.0d5e7b29@the-village.bc.nu>
	<1181254517.20322.6.camel@shinybook.infradead.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Jun 2007 23:15:17 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> On Thu, 2007-06-07 at 22:55 +0100, Alan Cox wrote:
> > Umm if your struct termios has the c_ispeed/c_ospeed fields then you
> > don't need to add the new ioctls to the PPC either - the Alpha is the
> > same here. 
> 
> Well, OK -- if it only involves editing patch files I might _send_ a
> patch tonight but I'll _test_ it in the morning... I think we only need
> this one hunk of what I sent before.

If it doesn't only involve editing the header files for this case (and
maybe needing a define to indicate old==new) then the tty layer wants
fixing to sort that out. Its on my todo list.

Alan
