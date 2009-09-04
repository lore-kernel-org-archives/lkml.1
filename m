Return-Path: <linux-kernel-owner+w=401wt.eu-S933859AbZIDS4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933859AbZIDS4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 14:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933850AbZIDS4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 14:56:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51281 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933824AbZIDS4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 14:56:09 -0400
Date: Fri, 4 Sep 2009 20:55:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Xiao Guangrong <ericxiao.gr@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jens Axboe <jens.axboe@oracle.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, x86@kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: reuse the boot-time mappings of fixed_addresses
Message-ID: <20090904185529.GA1874@elte.hu>
References: <4A90AADE.20307@gmail.com> <20090829110046.GA6812@elte.hu> <4A997088.60908@zytor.com> <20090831082632.GB15619@elte.hu> <4A9C6ADF.2020707@goop.org> <20090904073355.GA20598@elte.hu> <4AA1369A.5040204@goop.org> <4AA13D0F.6050502@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA13D0F.6050502@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 09/04/2009 08:47 AM, Jeremy Fitzhardinge wrote:
> > On 09/04/09 00:33, Ingo Molnar wrote:
> >>> It hardly seems worth it, but I guess it isn't much code. [...]
> >>>     
> >> Ok, i understood this as an Acked-by from you - lemme know if that's 
> >> wrong ;-)
> >>   
> > 
> > That's a bit proactive.  It's more "Meh-I-suppose-d-by: ".
> > 
> 
> Pretty much.  I suspect we'll have to undo this when we fix the 
> fixmap, since it will no longer be adjacent to the vmalloc range.

Ok, i've removed the patch from tip:x86/mm ...

	Ingo
