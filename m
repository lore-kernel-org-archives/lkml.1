Return-Path: <linux-kernel-owner+w=401wt.eu-S1754125AbYJAPlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbYJAPlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 11:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbYJAPlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 11:41:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37725 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753373AbYJAPlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 11:41:31 -0400
Date: Wed, 1 Oct 2008 16:41:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Noonan <steven@uplinklabs.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -tip] drivers/serial/8250.c: 'i' may be used
 uninitialized
Message-ID: <20081001164107.05c3c90e@lxorguk.ukuu.org.uk>
In-Reply-To: <20081001105741.GA32062@elte.hu>
References: <1222847847-7127-1-git-send-email-steven@uplinklabs.net>
	<1222847847-7127-2-git-send-email-steven@uplinklabs.net>
	<1222847847-7127-3-git-send-email-steven@uplinklabs.net>
	<20081001080150.GC25832@elte.hu>
	<20081001113343.4bf25ea5@lxorguk.ukuu.org.uk>
	<20081001105741.GA32062@elte.hu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> it cannot be wrapped like that via __foo style notation (which can be 
> used for section tricks), and uninitialized_var() is the accepted 

Any particular reason that

#define __used		__attribute__((used))

doesn't work ?

> > (Besides which last time I checked current gcc could figure that one 
> > out)
> 
> that would indeed moot the patch.

I'll re-check that before rejecting the patch definitively just to be
sure.

Alan
