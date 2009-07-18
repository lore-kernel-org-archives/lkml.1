Return-Path: <linux-kernel-owner+w=401wt.eu-S1751321AbZGRMDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321AbZGRMDG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 08:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751151AbZGRMDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 08:03:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59415 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbZGRMDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 08:03:03 -0400
Date: Sat, 18 Jul 2009 14:01:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Anton Vorontsov <avorontsov@ru.mvista.com>,
       Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Steven Rostedt <srostedt@redhat.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH RFC 1/2] Makefile: Never use -fno-omit-frame-pointer
Message-ID: <20090718120145.GB31007@elte.hu>
References: <20090616201630.GA4971@oksana.dev.rtsoft.ru> <20090714133716.GC28970@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090714133716.GC28970@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


* Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> On Wed, Jun 17, 2009 at 12:16:30AM +0400, Anton Vorontsov wrote:
> > According to Segher Boessenkool and GCC manual, -fomit-frame-pointer
> > is only the default when optimising on archs/ABIs where it doesn't
> > hinder debugging and -pg. So, we do not get it by default on x86,
> > not at any optimisation level.
> > 
> > On the other hand, *using* -fno-omit-frame-pointer causes gcc to
> > produce buggy code on PowerPC targets.
> > 
> > If Segher and GCC manual are right, this patch should be a no-op
> > for all arches except PowerPC, where the patch fixes gcc issues.
> > 
> > Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> > ---
> > 
> > See this thread for more discussion:
> > http://osdir.com/ml/linux-kernel/2009-05/msg01754.html
> > 
> > p.s.
> > Obviously, I didn't test this patch on anything else but PPC32. ;-)
> > 
> > Segher, do you know if all GCC versions that we support for
> > building Linux are behaving the way that GCC manual describe?
> 
> No news is good news... Ingo, can we merge this into -tip for 
> testing?

Changes to the top level Makefile should really go via Sam's kbuild 
tree.

	Ingo
