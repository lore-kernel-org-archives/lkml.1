Return-Path: <linux-kernel-owner+w=401wt.eu-S1755708AbYGITep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708AbYGITep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 15:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753462AbYGITef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 15:34:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45641 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998AbYGITee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 15:34:34 -0400
Date: Wed, 9 Jul 2008 21:34:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
Message-ID: <20080709193404.GC4804@elte.hu>
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <4874F30C.8020800@zytor.com> <4874F909.7060503@goop.org> <4874FEDF.90404@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4874FEDF.90404@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> > This fragility makes me very nervous.  It seems hard enough to get 
> > this stuff working with current tools; making it work over the whole 
> > range of supported tools looks like its going to be hard.
> 
> (me too ;-)
> 
> Once I get a solid version working with (at least) gcc-4.2.4, then 
> regression testing with older tools will be easier, or at least a 
> table of results can be produced.

the problem is, we cannot just put it even into tip/master if there's no 
short-term hope of fixing a problem it triggers. gcc-4.2.3 is solid for 
me otherwise, for series of thousands of randomly built kernels.

can we just leave out the zero-based percpu stuff safely and could i 
test the rest of your series - or are there dependencies? I think 
zero-based percpu, while nice in theory, is probably just a very small 
positive effect so it's not a life or death issue. (or is there any 
deeper, semantic reason why we'd want it?)

	Ingo
