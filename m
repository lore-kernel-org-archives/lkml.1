Return-Path: <linux-kernel-owner+w=401wt.eu-S1753514AbZEIDyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbZEIDyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 23:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbZEIDyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 23:54:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35571 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbZEIDyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 23:54:14 -0400
Date: Sat, 9 May 2009 05:54:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] groups: move code to kernel/groups.c
Message-ID: <20090509035401.GA8007@elte.hu>
References: <20090509033501.GA3224@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090509033501.GA3224@x200.localdomain>
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


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> Move supplementary groups implementation to kernel/groups.c .
> kernel/sys.c already accumulated quite a few random stuff.
> 
> Do strictly copy/paste + add required headers to compile.
> Compile-tested on many configs and archs.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  kernel/Makefile |    1 
>  kernel/groups.c |  288 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/sys.c    |  283 -------------------------------------------------------
>  3 files changed, 289 insertions(+), 283 deletions(-)

If you touch this code (which code has not been touched for years), 
do it only if you are also willing to do a followup patch that fixes 
most of these checkpatch warnings:

  total: 1 errors, 9 warnings, 0 checks, 584 lines checked

(Most of these are valid - and there's some other low hanging fruits 
as well which you will notice if you read the file.)

When creating a new file in kernel/ there's just no excuse for not 
doing it cleanly.

Thanks,

	Ingo
