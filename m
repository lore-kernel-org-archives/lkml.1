Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbYJAK6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbYJAK6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 06:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbYJAK56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 06:57:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49639 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715AbYJAK55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 06:57:57 -0400
Date: Wed, 1 Oct 2008 12:57:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Steven Noonan <steven@uplinklabs.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -tip] drivers/serial/8250.c: 'i' may be used
	uninitialized
Message-ID: <20081001105741.GA32062@elte.hu>
References: <1222847847-7127-1-git-send-email-steven@uplinklabs.net> <1222847847-7127-2-git-send-email-steven@uplinklabs.net> <1222847847-7127-3-git-send-email-steven@uplinklabs.net> <20081001080150.GC25832@elte.hu> <20081001113343.4bf25ea5@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081001113343.4bf25ea5@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Wed, 1 Oct 2008 10:01:50 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > ( Alan Cc:-ed. Seems like gcc bogosity - so your solution of using
> >   uninitialized_var() is the correct way to annotate this. )
> 
> Sorry but uninitialized_var() is too ugly to be acceptable. Please use 
> a proper __foo style notation for consistency with the rest of the 
> kernel

it cannot be wrapped like that via __foo style notation (which can be 
used for section tricks), and uninitialized_var() is the accepted 
upstream facility for this, it got introduced 1.5 years ago, via commit 
94909914 ("Add unitialized_var() macro for suppressing gcc warnings").

> (Besides which last time I checked current gcc could figure that one 
> out)

that would indeed moot the patch.

	Ingo
