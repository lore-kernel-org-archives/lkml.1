Return-Path: <linux-kernel-owner+w=401wt.eu-S964835AbXBZJvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964835AbXBZJvI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 04:51:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933800AbXBZJvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 04:51:08 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:43831 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932608AbXBZJvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 04:51:07 -0500
X-Originating-Ip: 74.109.98.130
Date: Mon, 26 Feb 2007 04:44:25 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
Subject: Re: [PATCH] Remove redundant #ifdef __KERNEL__ checks.
In-Reply-To: <45E2926C.40009@zytor.com>
Message-ID: <Pine.LNX.4.64.0702260442160.15535@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0702251509440.27758@CPE00045a9c397f-CM001225dbafb6>
 <45E2926C.40009@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Feb 2007, H. Peter Anvin wrote:

> Robert P. J. Day wrote:
> >   Remove the redundant intermediate checks for __KERNEL__ since, as
> > soon as one ends, the next one starts.
> >
> > Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> >
>
> However, what's much worse is that this already has put series of
> constants which are part of the ABI under __KERNEL__.  This is a
> very bad thing.

i'm sure i'm just being dense but i have no clue what you're referring
to.  AFAICT, that patch simply removed some redundant preprocessor
directives.  am i missing something?

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
