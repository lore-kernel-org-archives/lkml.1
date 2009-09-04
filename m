Return-Path: <linux-kernel-owner+w=401wt.eu-S932611AbZIDHei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611AbZIDHei (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 03:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbZIDHef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 03:34:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49693 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181AbZIDHef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 03:34:35 -0400
Date: Fri, 4 Sep 2009 09:33:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Xiao Guangrong <ericxiao.gr@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jens Axboe <jens.axboe@oracle.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, x86@kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: reuse the boot-time mappings of fixed_addresses
Message-ID: <20090904073355.GA20598@elte.hu>
References: <4A90AADE.20307@gmail.com> <20090829110046.GA6812@elte.hu> <4A997088.60908@zytor.com> <20090831082632.GB15619@elte.hu> <4A9C6ADF.2020707@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9C6ADF.2020707@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> On 08/31/09 01:26, Ingo Molnar wrote:
> >>> I'm wondering, how much space do we save this way, on a typical bootup 
> >>> on a typical PC?
> >>>
> >>>       
> >> Not a huge lot... a few dozen pages.
> >>     
> > I guess it's still worth doing - what do you think?
> >   
> 
> It hardly seems worth it, but I guess it isn't much code. [...]

Ok, i understood this as an Acked-by from you - lemme know if that's 
wrong ;-)

> [...]  Will having an apparent overlap of vmalloc and fixmap 
> spaces confuse anything?

At most perhaps some debug tools - kcrash & co.

	Ingo
