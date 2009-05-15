Return-Path: <linux-kernel-owner+w=401wt.eu-S1753829AbZEOTfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbZEOTfO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 15:35:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbZEOTe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 15:34:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45585 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941AbZEOTe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 15:34:59 -0400
Date: Fri, 15 May 2009 21:34:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, chrisw@sous-sol.org,
       oleg@redhat.com, roland@redhat.com, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk
Subject: Re: [patch 1/2] ptrace, security: rename ptrace_may_access =>
	ptrace_access_check
Message-ID: <20090515193439.GF22312@elte.hu>
References: <20090507082027.GD12285@elte.hu> <20090507083102.GA20125@redhat.com> <20090507083851.GA19133@elte.hu> <20090507085742.GB3036@sequoia.sous-sol.org> <20090507090459.GE19133@elte.hu> <20090507093124.GA355@elte.hu> <20090507094947.GA4911@elte.hu> <20090507125526.c257c23d.akpm@linux-foundation.org> <20090511133949.GA28533@elte.hu> <2375c9f90905141810qc7a4c3eg7b800aaf8aac2e7b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2375c9f90905141810qc7a4c3eg7b800aaf8aac2e7b@mail.gmail.com>
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


* Américo Wang <xiyou.wangcong@gmail.com> wrote:

> On Mon, May 11, 2009 at 9:39 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > I.e. any function name that can be plain-English answered with:
> > 'yes' or 'no' is a red flag for a retval function.
> >
> > You cannot answer ptrace_access_check() with 'yes' or 'no'. You
> > could if it was ptrace_access_ok() or ptrace_may_access.
> 
> Aha, then why do you agree with this patch? You don't see 
> ptrace_access_check() returns bool?? :-)

except that it doesnt ...

	Ingo
