Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbZEPPJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbZEPPJq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 11:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753755AbZEPPJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 11:09:35 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:43674 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbZEPPJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 11:09:35 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Security] [patch] random: make get_random_int() more random
Date: Sat, 16 May 2009 10:09:28 -0500
User-Agent: KMail/1.9.9
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       Willy Tarreau <w@1wt.eu>,
       Linus Torvalds <torvalds@linux-foundation.org>, security@kernel.org,
       Linux@hera.kernel.org, stable@kernel.org,
       Cox <alan@lxorguk.ukuu.org.uk>, Arjan@hera.kernel.org,
       List <linux-kernel@vger.kernel.org>, Alan@hera.kernel.org,
       Eric Paris <eparis@redhat.com>, Jake Edge <jake@lwn.net>,
       linux-security-module@vger.kernel.org, mingo@redhat.com,
       Matt Mackall <mpm@selenic.com>, Dave Jones <davej@redhat.com>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
References: <20090505195246.GC21973@elte.hu> <200905160928.19876.lkml@morethan.org> <20090516075746.4b8f3ed6@infradead.org>
In-Reply-To: <20090516075746.4b8f3ed6@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905161009.32178.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat May 16 2009, Arjan van de Ven wrote:
> On Sat, 16 May 2009 09:28:16 -0500
> "Michael S. Zick" <lkml@morethan.org> wrote:
> > 
> > Still getting kernel messages that there isn't a test for the rng - -
> > One (of many) ways to test the quality is to submit a bit string
> > sample to the Berlekamp-Massey algorithm; perhaps from repeated calls
> > to the generation function (it depends on your desired confidence
> > level).
> > 
> 
> or we bite the bullet and implement the Fortuna PRNG algorithm
> and feed it as much as we can, rather than caring if any if the sources
> is not 100.000% perfect.
> 

A reasonable cross-platform solution.
I just had to ping for supporting the VIA specific hardware solution.

Mike
