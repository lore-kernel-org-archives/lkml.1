Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbYHDLoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbYHDLoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 07:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbYHDLoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 07:44:11 -0400
Received: from ozlabs.org ([203.10.76.45]:34298 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbYHDLoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 07:44:10 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Introduce down_try() so we can move away from down_trylock()
Date: Mon, 4 Aug 2008 21:43:56 +1000
User-Agent: KMail/1.9.9
References: <200807291015.02865.rusty@rustcorp.com.au> <200808041757.05323.rusty@rustcorp.com.au> <20080804094507.61b68eba@lxorguk.ukuu.org.uk>
In-Reply-To: <20080804094507.61b68eba@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808042143.57174.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 August 2008 18:45:07 you wrote:
> >       down_trylock -> down_try in drivers/watchdog/ar7_wdt.c
> >       down_trylock -> down_try in drivers/watchdog/it8712f_wdt.c
> >       down_trylock -> down_try in drivers/watchdog/s3c2410_wdt.c
> >       down_trylock -> down_try in drivers/watchdog/sc1200wdt.c
> >       down_trylock -> down_try in drivers/watchdog/scx200_wdt.c
> >       down_trylock -> down_try in drivers/watchdog/wdt_pci.c
>
> I sent fixes for all of those to the watchdog maintainer in May. The
> patches are still sitting with the maintainer. They all convert to proper
> locking rather than sem abuse, clean up all the coding style and fix
> numerous bugs plus remove BKL requirements.
>
> Wim it appears is still trying to get real life stuff sorted out so I
> think at this point we really need a new watchdog maintainer.

Perhaps if noone steps forward soon you should shepherd them through 
linux-next for the next merge window?

Rusty.

