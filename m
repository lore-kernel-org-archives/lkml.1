Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472AbZALIfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbZALIfO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 03:35:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbZALIe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 03:34:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33959 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbZALIe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 03:34:59 -0500
Date: Mon, 12 Jan 2009 09:34:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org, Olof Johansson <olof@lixom.net>,
       arndb <arndb@arndb.de>
Subject: Re: [PATCH] powerpc: Fix cpufreq drivers after cpufreq core changes
Message-ID: <20090112083412.GB19701@elte.hu>
References: <20090112104837.69feedec.sfr@canb.auug.org.au> <1231719015.22571.4.camel@pasglop> <1231719721.22571.9.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231719721.22571.9.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2164]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> This updates the cpufreq drivers in arch/powerpc so they build again
> after the core cpufreq changes that broke them in commit
> in835481d9bcd65720b473db6b38746a74a3964218.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
> 
> Tested on a G5. Olof, Arnd, any chance you can test the cell and pasemi
> drivers still work ?
> 
> Linus, you can probably merge this now to fix the build problems.

Thanks Ben!

The powerpc defconfig built fine - you might wan to turn on cpufreq in the 
powerpc defconfig so that cross-build tests can catch problems like this.

	Ingo
