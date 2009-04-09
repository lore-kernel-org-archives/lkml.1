Return-Path: <linux-kernel-owner+w=401wt.eu-S1759085AbZDIDqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759085AbZDIDqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 23:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757997AbZDIDqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 23:46:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51477 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757749AbZDIDq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 23:46:29 -0400
Date: Thu, 9 Apr 2009 05:46:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       eric@lammerts.org, hpa@zytor.com
Subject: Re: [PATCH][retry 6] Conform L3 Cache Index Disable to Linux
	Standards
Message-ID: <20090409034608.GA20692@elte.hu>
References: <200903171457.25582.mark.langsdorf@amd.com> <200904081602.34320.mark.langsdorf@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904081602.34320.mark.langsdorf@amd.com>
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


* Mark Langsdorf <mark.langsdorf@amd.com> wrote:

> commit eb40831ca29a89f056f8c6128c8b36d3691f6698
> Author: Mark Langsdorf <mlangsdo@acernow.amd.com>
> Date:   Wed Apr 8 15:48:45 2009 -0500
> 
>     Add ABI Documentation entry and fix some /sys directory formating
>     issues with the L3 Cache Index Disable feature for future AMD
>     processors.  Add a check to disable it for family 0x10 models
>     that do not support it yet.
>     
>     Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>

Could you please send a delta patch against the tip:x86/cpu branch, 
which currently contains an earlier (broken) patch of yours:

  45ca863: x86, cpu: conform L3 Cache Index Disable to Linux standards

You can get that branch by doing:

  git checkout tip/x86/cpu

After having picked up -tip as a remote repository as per:

  http://people.redhat.com/mingo/tip.git/README

Thanks,

	Ingo
