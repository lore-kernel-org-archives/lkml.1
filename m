Return-Path: <linux-kernel-owner+w=401wt.eu-S1758623AbYGRMd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623AbYGRMd3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 08:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbYGRMdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 08:33:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51449 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899AbYGRMdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 08:33:20 -0400
Date: Fri, 18 Jul 2008 14:33:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: "Ricardo M. Correia" <Ricardo.M.Correia@Sun.COM>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arch <linux-arch@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       heukelum@fastmail.fm
Subject: Re: [PATCH] x86: fix description of __fls(): __fls(0) is undefined
Message-ID: <20080718123300.GP6875@elte.hu>
References: <20080315172913.GA21648@mailshack.com> <20080315173236.GC21659@mailshack.com> <1215276997.7167.12.camel@localhost> <20080705175345.GA7698@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080705175345.GA7698@mailshack.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander van Heukelum <heukelum@mailshack.com> wrote:

> Ricardo M. Correia spotted that the use of __fls() in fls64() did not 
> seem to make sense. In fact fls64()'s implementation is fine, but the 
> description of __fls() was wrong. Fix that.
> 
> Reported-by: "Ricardo M. Correia" <Ricardo.M.Correia@Sun.COM>
> Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

applied to tip/x86/cleanups, thanks!

	Ingo
