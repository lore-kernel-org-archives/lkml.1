Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758591AbYLPV6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591AbYLPV6U (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 16:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbYLPV6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 16:58:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55576 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbYLPV6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 16:58:07 -0500
Date: Tue, 16 Dec 2008 22:57:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <srostedt@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>
Subject: Re: [PATCH] x86: entry_64 - introduce FTRACE_ frame macro v2
Message-ID: <20081216215753.GZ14787@elte.hu>
References: <20081212210908.GA30557@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081212210908.GA30557@localhost>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Impact: clean up
> 
> Itroduce FTRACE_SAVE/RESTORE_FRAME which allow us to
> save a number of lines on source level.
> 
> Also fix a comment in ftrace.h.
> ---
> 
> Didn't add Steve's Ack since it's a new version
> 
>  arch/x86/include/asm/ftrace.h |   29 ++++++++++++++++++++-
>  arch/x86/kernel/entry_64.S    |   57 +++++-------------------------------------
>  2 files changed, 35 insertions(+), 51 deletions(-)

applied to tip/tracing/ftrace, thanks Cyrill!

i renamed it from FTRACE_* to MCOUNT_* - since that's where these frame 
details come from - these are stubs around GCC generated mcount calls.

	Ingo
