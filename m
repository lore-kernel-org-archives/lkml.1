Return-Path: <linux-kernel-owner+w=401wt.eu-S932326AbYBFXPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326AbYBFXPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764190AbYBFXLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:11:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43433 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762348AbYBFXLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:11:40 -0500
Date: Thu, 7 Feb 2008 00:10:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Hugh Dickins <hugh@veritas.com>,
       Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Document randomize_va_space and CONFIG_COMPAT_BRK (was
	Re: [PATCH 2/2] ASLR: add possibility for more fine-grained
	tweaking)
Message-ID: <20080206231040.GA6225@elte.hu>
References: <Pine.LNX.4.64.0802061438150.30955@jikos.suse.cz> <Pine.LNX.4.64.0802061442300.30955@jikos.suse.cz> <20080206134959.GA25689@elte.hu> <Pine.LNX.4.64.0802061650230.30955@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802061650230.30955@jikos.suse.cz>
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


* Jiri Kosina <jkosina@suse.cz> wrote:

> On Wed, 6 Feb 2008, Ingo Molnar wrote:
> 
> > i've already added the patch below to x86.git.
> 
> OK, cool, thanks.
> 
> Still, I think that we want the Documentation/sysctl/kernel.txt part 
> of my patch probably. Updated patch below.

thanks, applied.

i'm wondering about the following detail: i guess on 64-bit x86 kernels 
we could default to !CONFIG_COMPAT_BRK? In 1997 there was no 64-bit x86. 
Maybe for compat 32-bit binaries we could keep it off, but always do it 
for 64-bit binaries.

	Ingo
