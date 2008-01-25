Return-Path: <linux-kernel-owner+w=401wt.eu-S1753258AbYAYKt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbYAYKt6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 05:49:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbYAYKtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 05:49:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47252 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbYAYKtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 05:49:49 -0500
Date: Fri, 25 Jan 2008 11:49:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] x86, i387:  use convert_to_fxsr() in fpregs_set()
Message-ID: <20080125104934.GA4836@elte.hu>
References: <20080125014059.GA5342@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080125014059.GA5342@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0004]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Siddha, Suresh B <suresh.b.siddha@intel.com> wrote:

> Roland, Just happen to notice this bug. Can you please ack the bug fix 
> which needs to goto x86 mm tree.

nice one! I'm wondering, how did you notice this bug? Did something 
crash? Did FPU state get corrupted?

(i've applied Roland's followup patch to x86.git)

	Ingo
