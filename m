Return-Path: <linux-kernel-owner+w=401wt.eu-S1759573AbZCSHZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759573AbZCSHZh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 03:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754926AbZCSHZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 03:25:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43340 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303AbZCSHZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 03:25:28 -0400
Date: Thu, 19 Mar 2009 08:25:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Restrict definition of a variable in
	kernel/sysctl.c
Message-ID: <20090319072510.GA10584@elte.hu>
References: <1237412967-20754-1-git-send-email-dmitri.vorobiev@movial.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237412967-20754-1-git-send-email-dmitri.vorobiev@movial.com>
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


* Dmitri Vorobiev <dmitri.vorobiev@movial.com> wrote:

> The variable "one" in kernel/sysctl.c is used only if either CONFIG_HIGHMEM,
> or CONFIG_DETECT_SOFTLOCKUP are defined (or both). Hence, if neither option
> is enabled, the following error is produced:
> 
>   CC      kernel/sysctl.o
> kernel/sysctl.c:99: warning: 'one' defined but not used
> 
> This patch fixes the warning by moving the variable definition under an
> appropriate preprocessor construct.
> 
> Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
> ---
>  kernel/sysctl.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)

Note, this warning is already fixed in the tip:core/softlockup tree 
and queued up for v2.6.30.

	Ingo
