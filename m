Return-Path: <linux-kernel-owner+w=401wt.eu-S1763188AbYCFJVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763188AbYCFJVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 04:21:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758529AbYCFJVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 04:21:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34276 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757453AbYCFJV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 04:21:29 -0500
Date: Thu, 6 Mar 2008 10:21:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Aurelien Jarno <aurelien@aurel32.net>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Clear DF before calling signal handler
Message-ID: <20080306092102.GB12919@elte.hu>
References: <20080305153020.GA24631@volta.aurel32.net> <20080305181424.GA12678@hall.aurel32.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080305181424.GA12678@hall.aurel32.net>
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


* Aurelien Jarno <aurelien@aurel32.net> wrote:

> The Linux kernel currently does not clear the direction flag before 
> calling a signal handler, whereas the x86/x86-64 ABI requires that. 
> This become a real problem with gcc version 4.3, which assumes that 
> the direction flag is correctly cleared at the entry of a function.
> 
> This patches changes the setup_frame() functions to clear the 
> direction before entering the signal handler.

thanks, applied.

	Ingo
