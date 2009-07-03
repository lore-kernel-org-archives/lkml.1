Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320AbZGCJDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbZGCJDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 05:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbZGCJDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 05:03:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33069 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbZGCJDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 05:03:25 -0400
Date: Fri, 3 Jul 2009 11:03:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [git pull] dma-debug fixes for 2.6.31-rc1
Message-ID: <20090703090323.GA31461@elte.hu>
References: <1246609924-31217-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246609924-31217-1-git-send-email-joerg.roedel@amd.com>
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


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> Hi Ingo,
> 
> The following changes since commit 7c5371c403abb29f01bc6cff6c5096abdf2dc524:
>   Yinghai Lu (1):
>         x86: add boundary check for 32bit res before expand e820 resource to alignment
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git dma-debug/fixes
> 
> Ingo Molnar (1):
>       dma-debug: Put all hash-chain locks into the same lock class
> 
> Joerg Roedel (1):
>       dma-debug: fix off-by-one error in overlap function
> 
>  lib/dma-debug.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> These patches make dma-debug work better with lockdep enabled and 
> fix a corner case in the overlap function were one region ends 
> exactly where the other one begins. Please pull.

Pulled, thanks Joerg!

	Ingo
