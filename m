Return-Path: <linux-kernel-owner+w=401wt.eu-S1757554AbZJDRjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554AbZJDRjQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 13:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757207AbZJDRjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 13:39:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49725 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756098AbZJDRjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 13:39:12 -0400
Date: Sun, 4 Oct 2009 19:38:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chris Wilson <chris@chris-wilson.co.uk>, Mike Galbraith <efault@gmx.de>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: Propagate term signal to child
Message-ID: <20091004173806.GA24418@elte.hu>
References: <1254616502-4728-1-git-send-email-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254616502-4728-1-git-send-email-chris@chris-wilson.co.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4942]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Chris Wilson <chris@chris-wilson.co.uk> wrote:

> If we launch the child on behalf of the user, ensure that it dies along
> with ourselves when we are interrupted.
> 
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> ---
>  tools/perf/builtin-record.c |    6 ++++++
>  tools/perf/builtin-stat.c   |    8 +++++++-
>  2 files changed, 13 insertions(+), 1 deletions(-)

Applied, thanks Chris!

	Ingo
