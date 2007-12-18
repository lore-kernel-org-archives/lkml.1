Return-Path: <linux-kernel-owner+w=401wt.eu-S1759289AbXLRPt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289AbXLRPt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 10:49:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757822AbXLRPtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 10:49:51 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:44285 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757673AbXLRPtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 10:49:50 -0500
Date: Tue, 18 Dec 2007 10:49:49 -0500
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Pavel Machek <pavel@ucw.cz>, Rene Herman <rene.herman@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80 on some AMD64x2 laptops, etc.
Message-ID: <20071218154949.GG2310@csclub.uwaterloo.ca>
References: <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com> <20071214131502.GA14359@elte.hu> <4762C551.5070003@zytor.com> <20071214210652.GB28793@elf.ucw.cz> <4763001A.1070102@zytor.com> <20071214232955.545ab809@the-village.bc.nu> <4766E453.1030202@keyaccess.nl> <20071217232011.GB12647@elf.ucw.cz> <20071218000608.05493fa3@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071218000608.05493fa3@the-village.bc.nu>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 12:06:08AM +0000, Alan Cox wrote:
> 300MHz 486 -> Nat Semi Geode.
> 
> NextGen as you say are 386 - 586 depending on the BIOS hypercode but I
> believe lack WP even in > 386 mode.

Geode identifies itself as family 5 though.  It may prefer 486 code but
it's still family 5.  Well Geode GX, SCx200 and LX that is.  I imagine
the Geode NX would be family 6.

--
Len Sorensen
