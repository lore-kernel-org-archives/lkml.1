Return-Path: <linux-kernel-owner+w=401wt.eu-S1758735AbYKWMV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735AbYKWMV0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 07:21:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758255AbYKWMU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 07:20:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35136 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758234AbYKWMUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 07:20:55 -0500
Date: Sun, 23 Nov 2008 13:20:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: move dwarf2 related macro to dwarf2.h
Message-ID: <20081123122043.GF29663@elte.hu>
References: <20081123115343.GF24818@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123115343.GF24818@localhost>
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

> Impact: cleanup
> 
> Move recently introduced dwarf2 macros to dwarf2.h file.
> It allow us to not duplicate them in assembly files.
> 
> Active usage of _cfi macros don't make assembly files
> more obvious to understand but we already has a lot of
> macros there which requires to search the definitions
> of them *anyway*. But at least it make every cfi usage
> one line shorter.
> 
> Also some code alignment is done.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
> 
>  arch/x86/include/asm/dwarf2.h |   97 ++++++++++++++++++++++++++++--------------
>  arch/x86/kernel/entry_64.S    |   23 ---------
>  2 files changed, 66 insertions(+), 54 deletions(-)

applied to tip/x86/irq, thanks Cyrill!

	Ingo
