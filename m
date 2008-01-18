Return-Path: <linux-kernel-owner+w=401wt.eu-S1760567AbYARKog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760567AbYARKog (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 05:44:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760054AbYARKoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 05:44:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44004 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563AbYARKoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 05:44:23 -0500
Date: Fri, 18 Jan 2008 11:44:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6.24 patch] x86: allow 64bit setting in Kconfig
Message-ID: <20080118104401.GA8785@elte.hu>
References: <20080117214301.GA28233@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117214301.GA28233@does.not.exist>
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


* Adrian Bunk <bunk@kernel.org> wrote:

>  # Select 32 or 64 bit
>  config 64BIT
> -	bool "64-bit kernel" if ARCH = "x86"
> +	bool "64-bit kernel"
>  	default ARCH = "x86_64"
>  	help
>  	  Say yes to build a 64-bit kernel - formerly known as x86_64

thx, i've added this to x86.git.

	Ingo
