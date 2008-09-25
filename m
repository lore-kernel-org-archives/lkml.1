Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbYIYJQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbYIYJQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 05:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbYIYJQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 05:16:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58451 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380AbYIYJQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 05:16:08 -0400
Date: Thu, 25 Sep 2008 11:15:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86_64: be less annoying on boot
Message-ID: <20080925091558.GE16734@elte.hu>
References: <20080924183517.GA24209@nostromo.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080924183517.GA24209@nostromo.devel.redhat.com>
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


* Bill Nottingham <notting@redhat.com> wrote:

> As long as we're printing mostly useless messages on every boot regardless
> of debug level, make them 5% more amusing.
> 
> Signed-off-by: Bill Nottingham <notting@redhat.com>
> 
> (Alternatively, just remove them, of course...)

LOL :) Applied the commit below to tip/x86/debug, thanks Bill!

	Ingo

-------------------->
>From f6476774f1fe32593d3d71903b1e98514efbf685 Mon Sep 17 00:00:00 2001
From: Bill Nottingham <notting@redhat.com>
Date: Wed, 24 Sep 2008 14:35:17 -0400
Subject: [PATCH] x86_64: be less annoying on boot

Remove mostly useless message on every boot.

Signed-off-by: Bill Nottingham <notting@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/head64.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 9bfc4d7..11aa501 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -112,8 +112,6 @@ void __init x86_64_start_kernel(char * real_mode_data)
 
 	x86_64_init_pda();
 
-	early_printk("Kernel really alive\n");
-
 	x86_64_start_reservations(real_mode_data);
 }
 

