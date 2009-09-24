Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbZIXTwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbZIXTwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 15:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbZIXTwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 15:52:54 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:41483 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbZIXTwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 15:52:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YeJs6ZWhTzZHlHutwWLfZLJ5V3eiWjgFvfVw3KkfI8mvFprqwrUmyfe/fC38AsuSDi
         SG66jKmlKt0Dhd/1ETURM54FjIhmcHH93uul6vvtrHbMHMHeXc4CrNQhuJp6fcrZl9RE
         so22voWHE/w4yGj4WxMzOe5KDfptVDsE7ncAE=
Date: Thu, 24 Sep 2009 21:52:48 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jkacur@redhat.com, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf tools: Create util/sort.and use it
Message-ID: <20090924195246.GA8642@nowhere>
References: <alpine.LFD.2.00.0909241758390.11383@localhost.localdomain> <tip-dd68ada2d417e57b848822a1407b5317a54136c5@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-dd68ada2d417e57b848822a1407b5317a54136c5@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 07:37:05PM +0000, tip-bot for John Kacur wrote:
> Commit-ID:  dd68ada2d417e57b848822a1407b5317a54136c5
> Gitweb:     http://git.kernel.org/tip/dd68ada2d417e57b848822a1407b5317a54136c5
> Author:     John Kacur <jkacur@redhat.com>
> AuthorDate: Thu, 24 Sep 2009 18:02:49 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu, 24 Sep 2009 21:27:52 +0200
> 
> perf tools: Create util/sort.and use it
> 
> Create util/sort.[ch] and move common functionality for
> builtin-report.c and builtin-annotate.c there, and make use of it.
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>
> LKML-Reference: <alpine.LFD.2.00.0909241758390.11383@localhost.localdomain>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  tools/perf/Makefile           |    2 +
>  tools/perf/builtin-annotate.c |  211 +---------------------------
>  tools/perf/builtin-report.c   |  307 +----------------------------------------
>  tools/perf/util/sort.c        |  268 +++++++++++++++++++++++++++++++++++
>  tools/perf/util/sort.h        |   93 +++++++++++++
>  5 files changed, 373 insertions(+), 508 deletions(-)



Thanks a lot for this cleanup!

