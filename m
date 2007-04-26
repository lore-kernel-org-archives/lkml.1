Return-Path: <linux-kernel-owner+w=401wt.eu-S1031313AbXDZQYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031313AbXDZQYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 12:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031338AbXDZQYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 12:24:31 -0400
Received: from terminus.zytor.com ([192.83.249.54]:56442 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031313AbXDZQYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:24:30 -0400
Message-ID: <4630D116.4080202@zytor.com>
Date: Thu, 26 Apr 2007 09:19:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: David Acker <dacker@roinet.com>, "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Lennert Buytenhek <buytenh@wantstofly.org>,
       Jeff Garzik <jeff@garzik.org>, Netdev List <netdev@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [RFT] e100 driver on ARM
References: <44FC0261.6010807@garzik.org> <20060904123123.GB1285@xi.wantstofly.org> <460AF480.7050609@intel.com> <460B4BF2.1070803@roinet.com> <20070329141041.GA3510@csclub.uwaterloo.ca> <46239138.4040408@roinet.com> <20070417173507.GB5575@csclub.uwaterloo.ca>
In-Reply-To: <20070417173507.GB5575@csclub.uwaterloo.ca>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> 
> My suspicision (although it is only that) is that the PXA255 trying to
> access memory may cause interruptions in PCI bus master transfers, which
> is of course not permitted by the PCI spec (at least the way I read it).

Why wouldn't that be permitted?  It, in fact, happens all the time (the
host bridge withdraws the GNT# line and raises STOP#, which does a
Termination With Data of the bus transfer.)  This is a normal event and
if you can't handle it you won't work with many host bridges at all.

	-hpa
