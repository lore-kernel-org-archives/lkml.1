Return-Path: <linux-kernel-owner+w=401wt.eu-S1759780AbYDKJDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759780AbYDKJDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 05:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758332AbYDKJDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 05:03:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58629 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758228AbYDKJDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 05:03:11 -0400
Date: Fri, 11 Apr 2008 11:03:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de
Subject: Re: [PATCH] x86: setup_trampoline() - fix section mismatch warning
Message-ID: <20080411090300.GC10801@elte.hu>
References: <47FE6799.9030606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FE6799.9030606@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0214]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jacek Luczak <difrost.kernel@gmail.com> wrote:

> Hi Ingo,
> 
> this patch fixes section mismatch warnings (on x86_64 host) in 
> setup_trampoline(), which was referencing __initdata variables 
> trampoline_data and trampoline_end.
> 
> Patch is against x86/latest.

thanks Jacek, applied.

> PS: Hope that my email client won't break patch this time. In case it 
> does - patch attached.

it worked just fine. (another minor nit: in future patches please 
include a Signed-off-by line.)

	Ingo
