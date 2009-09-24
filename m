Return-Path: <linux-kernel-owner+w=401wt.eu-S1752371AbZIXMCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbZIXMCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 08:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbZIXMCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 08:02:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50115 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949AbZIXMCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 08:02:23 -0400
Date: Thu, 24 Sep 2009 14:02:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kirill Smelkov <kirr@mns.spb.ru>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf_counter tools: .gitignore += perf*.html
Message-ID: <20090924120218.GC11013@elte.hu>
References: <1253790022-10300-1-git-send-email-kirr@mns.spb.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253790022-10300-1-git-send-email-kirr@mns.spb.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.3 required=5.9 tests=BAYES_00,SUBJECT_FUZZY_TION autolearn=no SpamAssassin version=3.2.5
	0.2 SUBJECT_FUZZY_TION     Attempt to obfuscate words in Subject:
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kirill Smelkov <kirr@mns.spb.ru> wrote:

> I've tried building the docs in tools/perf/Documentation/ , and after
> that `git status` showed dozen of untracked htmls. Let's ignore them.
> 
> Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
> ---
>  tools/perf/.gitignore |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/.gitignore b/tools/perf/.gitignore
> index d69a759..0854f11 100644
> --- a/tools/perf/.gitignore
> +++ b/tools/perf/.gitignore
> @@ -10,6 +10,7 @@ perf-stat
>  perf-top
>  perf*.1
>  perf*.xml
> +perf*.html
>  common-cmds.h
>  tags
>  TAGS

Applied to tip:perf/urgent, thanks!

Btw., if you want to try the latest tools tree, you can pick it up from:

  http://people.redhat.com/mingo/tip.git/README

	Ingo
