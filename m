Return-Path: <linux-kernel-owner+w=401wt.eu-S1754235AbZHLIyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbZHLIyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 04:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbZHLIyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 04:54:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51932 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778AbZHLIyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 04:54:52 -0400
Date: Wed, 12 Aug 2009 10:54:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma-debug: Allow archs to override
	check_for_illegal_area
Message-ID: <20090812085440.GA14114@elte.hu>
References: <1250005381-17903-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250005381-17903-1-git-send-email-joerg.roedel@amd.com>
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

> For some architectures (like sparc32) the default 
> check_for_illegal_area function does not work reliable. This patch 
> makes this function a weak symbol allowing architectures to 
> override it if necessary.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  lib/dma-debug.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)

Dave, you indicated that sparc32 would address this problem 
differently. Do we still need this patch (for .31 for example)?

	Ingo
