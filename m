Return-Path: <linux-kernel-owner+w=401wt.eu-S1755682AbYDGHqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682AbYDGHqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 03:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752791AbYDGHq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 03:46:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51486 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787AbYDGHq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 03:46:28 -0400
Date: Mon, 7 Apr 2008 09:46:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       heukelum@fastmail.fm
Subject: Re: [PATCH] x86: remove superfluous initialisation in boot code.
Message-ID: <20080407074614.GD2368@elte.hu>
References: <20080406124700.GA26669@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080406124700.GA26669@mailshack.com>
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


* Alexander van Heukelum <heukelum@mailshack.com> wrote:

> --- a/arch/x86/boot/compressed/misc.c
> +++ b/arch/x86/boot/compressed/misc.c
> @@ -223,7 +223,7 @@ static memptr free_mem_end_ptr;
>  #define HEAP_SIZE             0x4000
>  #endif
>  
> -static char *vidmem = (char *)0xb8000;
> +static char *vidmem;
>  static int vidport;

thanks, applied. (Btw., you forgot your signoff line - not a big deal 
for a small fix like this but it's best to always include it for patches 
you'd like to see go upstream.)

	Ingo
