Return-Path: <linux-kernel-owner+w=401wt.eu-S1763577AbYARUkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763577AbYARUkF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 15:40:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759396AbYARUjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 15:39:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46685 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760112AbYARUjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 15:39:55 -0500
Date: Fri, 18 Jan 2008 21:39:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: travis@sgi.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] percpu: Per cpu code simplification fixup
Message-ID: <20080118203928.GB3079@elte.hu>
References: <20080118182953.748071000@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080118182953.748071000@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* travis@sgi.com <travis@sgi.com> wrote:

> This patchset simplifies the code that arches need to maintain to 
> support per cpu functionality. Most of the code is moved into arch 
> independent code. Only a minimal set of definitions is kept for each 
> arch.
> 
> The patch also unifies the x86 arch so that there is only a single 
> asm-x86/percpu.h
> 
> Based on: 2.6.24-rc8-mm1

just to make sure i got it right: due to the multi-arch scope of this 
patchset, this is for -mm, right?

	Ingo
