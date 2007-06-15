Return-Path: <linux-kernel-owner+w=401wt.eu-S1757188AbXFOSaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188AbXFOSaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 14:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbXFOSaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 14:30:11 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:48938 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbXFOSaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 14:30:10 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 15 Jun 2007 14:28:16 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Optimize is_power_of_2().
In-Reply-To: <4672D89D.7010801@zytor.com>
Message-ID: <Pine.LNX.4.64.0706151427370.12949@localhost.localdomain>
References: <1181926602.25193.5.camel@grianne> <4672D89D.7010801@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2007, H. Peter Anvin wrote:

> Vegard Nossum wrote:
> > From: Vegard Nossum <vegard@peltkore.net>
> > Date: Fri, 15 Jun 2007 18:35:49 +0200
> > Subject: [PATCH] Optimize is_power_of_2().
> >
> > Rationale: Removes one conditional branch and reduces icache
> > footprint. Proof: If n is false, the product of n and any value is
> > false. If n is true, the truth of (n * x) is the truth of x.
>
> You realize that on a lot of platforms, multiplication is done by an
> out-of-line subroutine, and that even on those that aren't, it's
> generally a long-pipeline operation, right?

i was *just* about to mention somthing of the sort, but probably not
as succinctly.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
