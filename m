Return-Path: <linux-kernel-owner+w=401wt.eu-S1752846AbZADJVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbZADJVT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 04:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbZADJVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 04:21:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53188 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbZADJVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 04:21:05 -0500
Date: Sun, 4 Jan 2009 10:20:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/1] x86_64: fix RIP printout in early_idt_handler
Message-ID: <20090104092053.GB12938@elte.hu>
References: <1231025229-26352-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231025229-26352-1-git-send-email-jirislaby@gmail.com>
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


* Jiri Slaby <jirislaby@gmail.com> wrote:

> Since errorcode is popped out, RIP is on the top of the stack.
> Use real RIP value instead of wrong CS.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> ---
>  arch/x86/kernel/head_64.S |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

good spotting - applied to tip/x86/urgent, thanks Jiri. I have also added 
a -stable backport tag.

	Ingo
