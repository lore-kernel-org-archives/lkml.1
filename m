Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834AbZALLIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbZALLIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 06:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbZALLIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 06:08:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37216 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbZALLIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 06:08:04 -0500
Date: Mon, 12 Jan 2009 12:07:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Paul Mundt <lethal@linux-sh.org>, Greg Ungerer <gerg@snapgear.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "David S. Miller" <davem@davemloft.net>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>, Greg Ungerer <gerg@uclinux.org>,
       linux-m68k@vger.kernel.org, stable@kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH for 2.6.28 stable] m68knommu: fix m68knommu defconfig
	can't build
Message-ID: <20090112110739.GA17514@elte.hu>
References: <20081230193943.1281.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48E9AE16.2000002@snapgear.com> <20090112104447.GG28564@linux-sh.org> <20090112105942.GA10936@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112105942.GA10936@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> We just did the exercise with sparc/sparc64 unification and if you 
> forget the few times I broke sparc32 then it went well with only limited 
> problems.

We also had the x86 unification finished in the past year which went very 
well too, so i can only encourage similar efforts.

> One key factor why it went well was that patches were reviewed and 
> applied within a few days whch is why I stresses that the maintainer 
> needs spare time to support the effort.

Yes.

Unification is the Linux meme of the century i guess ;-)

There's two main unification themes:

 - per arch unification (x86, powerpc, sparc

 - cross-arch unification: the moving of useful stuff out of architectures 
   into the core kernel (genirq, gtod, etc.).

	Ingo
