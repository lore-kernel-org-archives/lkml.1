Return-Path: <linux-kernel-owner+w=401wt.eu-S1757065AbZCSITS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065AbZCSITS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 04:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbZCSITD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 04:19:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58975 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594AbZCSITA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 04:19:00 -0400
Date: Thu, 19 Mar 2009 09:18:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       eric@lammerts.org, hpa@zytor.com
Subject: Re: [PATCH][retry 5] Conform L3 Cache Index Disable to Linux
	Standards
Message-ID: <20090319081837.GA29795@elte.hu>
References: <200903171457.25582.mark.langsdorf@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903171457.25582.mark.langsdorf@amd.com>
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

> Add ABI Documentation entry and fix some /sys directory formating
> issues with the L3 Cache Index Disable feature for future AMD
> processors.  Add a check to disable it for family 0x10 models
> that do not support it properly.  Correct the disable algorithm
> to reflect erratum 388.
>     
> Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>

i'm still getting this build failure:

 arch/x86/mm/built-in.o:(.bss+0x3640): multiple definition of `k8_northbridges'

i've reported this build failure before. I've excluded this commit 
from tip:master for now.

	Ingo
