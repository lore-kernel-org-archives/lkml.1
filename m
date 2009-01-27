Return-Path: <linux-kernel-owner+w=401wt.eu-S1754062AbZA0KxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbZA0KxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 05:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbZA0KxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 05:53:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34716 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbZA0KxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 05:53:07 -0500
Date: Tue, 27 Jan 2009 11:52:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <htejun@gmail.com>
Cc: Brian Gerst <brgerst@gmail.com>, linux-kernel@vger.kernel.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] x86-32: Fix __per_cpu_load relocation
Message-ID: <20090127105251.GA10453@elte.hu>
References: <20090126103243.GA31307@elte.hu> <1232977445-11815-1-git-send-email-brgerst@gmail.com> <20090126141832.GA31442@elte.hu> <497E6B34.1020508@kernel.org> <497E8778.9060503@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497E8778.9060503@gmail.com>
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


* Tejun Heo <htejun@gmail.com> wrote:

> (cc'ing James Bottomley.)
> 
> Tejun Heo wrote:
> > Ingo Molnar wrote:
> >> * Brian Gerst <brgerst@gmail.com> wrote:
> >>
> >>> This patch fixes this error:
> >>> WARNING: Absolute relocations present
> >>> Offset     Info     Type     Sym.Value Sym.Name
> >>> c0a4e07d 00e78001   R_386_32 c0ab0000  __per_cpu_load
> >>>
> >>> Now, __per_cpu_load is a section-relative symbol:
> >>> c0aa4000 D __per_cpu_load
> >>> c0aa4000 A __per_cpu_load_abs
> >>>
> >>> Signed-off-by: Brian Gerst <brgerst@gmail.com>
> >> Applied to tip/core/percpu, thanks Brian!
> > 
> > Heh.. Thanks.  Sorry about lack of response.  It's lunar new year's
> > day here and I'm off till tomorrow.  I'll start reviewing and
> > integrating posted patches from tomorrow.
> 
> Well, I just had time to do it.  All the patches look fine to me.
> Very nice cleanup.  The git tree is at the following URL.
> 
>   http://git.kernel.org/?p=linux/kernel/git/tj/misc.git;a=shortlog;h=tj-percpu
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu

Pulled into tip/core/percpu, thanks Tejun!

	Ingo
