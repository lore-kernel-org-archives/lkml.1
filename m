Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504AbYJBJBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbYJBJBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 05:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbYJBJBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 05:01:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59490 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbYJBJBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 05:01:00 -0400
Date: Thu, 2 Oct 2008 11:00:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Steven Noonan <steven@uplinklabs.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -tip] drivers/serial/8250.c: 'i' may be used
	uninitialized
Message-ID: <20081002090044.GC3550@elte.hu>
References: <1222847847-7127-1-git-send-email-steven@uplinklabs.net> <1222847847-7127-2-git-send-email-steven@uplinklabs.net> <1222847847-7127-3-git-send-email-steven@uplinklabs.net> <20081001080150.GC25832@elte.hu> <20081001113343.4bf25ea5@lxorguk.ukuu.org.uk> <20081001105741.GA32062@elte.hu> <20081001164107.05c3c90e@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081001164107.05c3c90e@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0596]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > it cannot be wrapped like that via __foo style notation (which can be 
> > used for section tricks), and uninitialized_var() is the accepted 
> 
> Any particular reason that
> 
> #define __used		__attribute__((used))
> 
> doesn't work ?

ah, if that works then it's a very nice idea!

	Ingo
