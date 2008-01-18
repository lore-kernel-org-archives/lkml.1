Return-Path: <linux-kernel-owner+w=401wt.eu-S1764047AbYARSVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764047AbYARSVP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:21:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762331AbYARSUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:20:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44483 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762071AbYARSUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:20:48 -0500
Message-ID: <4790EB95.203@zytor.com>
Date: Fri, 18 Jan 2008 13:10:29 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: 7eggert@gmx.de, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       Russell King <rmk+serial@arm.linux.org.uk>,
       Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch 2/2] 8250_pnp: register x86 COM ports at the conventional
 ttyS names
References: <9MjWa-VI-9@gated-at.bofh.it> <9MjWb-VI-11@gated-at.bofh.it> <9MlEG-3Mx-13@gated-at.bofh.it> <9Mmra-56f-29@gated-at.bofh.it> <E1JFEwb-0000zs-2q@be1.7eggert.dyndns.org> <478E6C20.2030005@zytor.com> <478E946D.9040105@keyaccess.nl>
In-Reply-To: <478E946D.9040105@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> 
> The number of places expected to contain something sensible should I 
> believe first be verified at 0x410 -- the equipment word. Bits 11-9 
> (0x0e00) should be the number of serial ports, 0 to 4 (so 5-7 is also a 
> sanity check) and if BIOSes can be expected to zero out the non-used 
> base-addresses (at 0x400, 0x402, 0x404, 0x406) that's another sanity 
> check. Don't know if they can though...
> 

Probably not.  However, the ports marked valid should be nonzero and 
aligned-8.

	-hpa

