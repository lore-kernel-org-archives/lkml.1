Return-Path: <linux-kernel-owner+w=401wt.eu-S933941AbZJOGTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933941AbZJOGTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 02:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbZJOGTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 02:19:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59855 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbZJOGTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 02:19:30 -0400
Date: Thu, 15 Oct 2009 08:18:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, hpa@zytor.com,
       Ian Lance Taylor <iant@google.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] x86: linker script syntax nits
Message-ID: <20091015061807.GC32415@elte.hu>
References: <20091014221024.EFA79E2F@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091014221024.EFA79E2F@magilla.sf.frob.com>
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


* Roland McGrath <roland@redhat.com> wrote:

> The following changes since commit 80f506918fdaaca6b574ba931536a58ce015c7be:
>   Linus Torvalds (1):
>         Merge branch 'for-linus' of git://git.kernel.dk/linux-2.6-block
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-roland.git topic/x86-lds-nits
> 
> Roland McGrath (1):
>       x86: linker script syntax nits
> 
>  arch/x86/kernel/acpi/realmode/wakeup.lds.S |    4 ++--
>  arch/x86/kernel/vmlinux.lds.S              |   17 ++++++++---------
>  2 files changed, 10 insertions(+), 11 deletions(-)
> ---
> [PATCH] x86: linker script syntax nits
> 
> The linker scripts grew some use of weirdly wrong linker script syntax.
> It happens to work, but it's not what the syntax is documented to be.
> Clean it up to use the official syntax.

I've queued up a revert based on Peter's and Sam's objections.

I'd also like to point out a few commit log quality nits. A standard x86 
commit should have the following title:

    x86: Clean up linker script syntax nits

not:

    x86: linker script syntax nits

Note that we always try to add a verb to that sentence, so that it's 
more natural-language alike. (also note the capitalization (we 
capitalize the sentence after the 'x86:' prefix))

(Plus i always try to line-wrap the commit log to 65 columns, to make it 
easy to quote to several levels and still be within the various viewer 
column widths that people use - and to allow for the +4 columns used up 
by git log's indentation.)

Thanks,

	Ingo
