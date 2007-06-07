Return-Path: <linux-kernel-owner+w=401wt.eu-S1762165AbXFGPdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762165AbXFGPdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 11:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751100AbXFGPdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 11:33:07 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49862 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750923AbXFGPdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 11:33:04 -0400
Date: Thu, 7 Jun 2007 16:38:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, paulus@samba.org
Subject: Re: [SERIAL] Don't optimise away baud rate changes when BOTHER is
 used
Message-ID: <20070607163808.19984208@the-village.bc.nu>
In-Reply-To: <1181150998.2785.13.camel@pmac.infradead.org>
References: <20070523172739.1d3a918c@the-village.bc.nu>
	<1180012135.8303.89.camel@shinybook.infradead.org>
	<20070524144109.7bd0f4d0@the-village.bc.nu>
	<1180014338.8303.95.camel@shinybook.infradead.org>
	<20070524160559.54c2c639@the-village.bc.nu>
	<1181133010.4096.26.camel@pmac.infradead.org>
	<20070606160310.27d6d3b8@the-village.bc.nu>
	<1181150998.2785.13.camel@pmac.infradead.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Jun 2007 18:29:58 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> On Wed, 2007-06-06 at 16:03 +0100, Alan Cox wrote:
> > Yep - and there are some other changes needed as well once everyone
> > gets their ports properly lined up (notably handing back the actual
> > speed). 
> 
> Yeah, probably. This was was required just to get the speed thing to
> pass basic testing though.
> 
> You earlier made a cryptic comment about asm-generic and said the
> PowerPC patch wouldn't work -- I didn't understand, and it doesn't seem
> to be empirically confirmed. Can you eludicate?

If your termios and termios2 structures differ in size then you need to
copy the right number of bytes or you won't get speed values into the
kernel. If they are the same size it wont matter.
