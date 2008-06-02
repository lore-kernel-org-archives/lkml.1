Return-Path: <linux-kernel-owner+w=401wt.eu-S1756520AbYFBPEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520AbYFBPEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 11:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbYFBPEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 11:04:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34758 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804AbYFBPEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 11:04:43 -0400
Date: Mon, 2 Jun 2008 17:04:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 1/1] SGI UV: TLB shootdown using broadcast assist unit
Message-ID: <20080602150427.GA16096@elte.hu>
References: <E1K3AWE-00056Z-83@eag09.americas.sgi.com> <20080602150122.GB6835@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080602150122.GB6835@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > TLB shootdown for SGI UV.
> 
> looks mostly good to me, but there are a few code structure and 
> stylistic nits:

i've created a new branch for this in -tip, you can find it in 
tip/x86/uv, under:

  http://people.redhat.com/mingo/tip.git/README

this new topic branch is based on tip/x86/irq and this is intended to be 
a temporary branch until these changes become mergable into tip/x86/irq 
[where for example the "x86, uv: update macros used by UV platform" 
commit lives]. Please send fix patches against this branch.

	Ingo
