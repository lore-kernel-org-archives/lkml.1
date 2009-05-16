Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbZEPO6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbZEPO6u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 10:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753337AbZEPO6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 10:58:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:50402 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953AbZEPO6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 10:58:40 -0400
Date: Sat, 16 May 2009 07:57:46 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: lkml@morethan.org
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
Subject: Re: [Security] [patch] random: make get_random_int() more random
Message-ID: <20090516075746.4b8f3ed6@infradead.org>
In-Reply-To: <200905160928.19876.lkml@morethan.org>
References: <20090505195246.GC21973@elte.hu>
	<m1bpptw90d.fsf@fess.ebiederm.org>
	<200905160900.04380.lkml@morethan.org>
	<200905160928.19876.lkml@morethan.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 May 2009 09:28:16 -0500
"Michael S. Zick" <lkml@morethan.org> wrote:
> 
> Still getting kernel messages that there isn't a test for the rng - -
> One (of many) ways to test the quality is to submit a bit string
> sample to the Berlekamp-Massey algorithm; perhaps from repeated calls
> to the generation function (it depends on your desired confidence
> level).
> 

or we bite the bullet and implement the Fortuna PRNG algorithm
and feed it as much as we can, rather than caring if any if the sources
is not 100.000% perfect.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
