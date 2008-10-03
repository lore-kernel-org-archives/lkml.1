Return-Path: <linux-kernel-owner+w=401wt.eu-S1754797AbYJCJAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbYJCJAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 05:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbYJCJAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 05:00:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36274 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbYJCJAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 05:00:05 -0400
Date: Fri, 3 Oct 2008 10:59:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dean Nelson <dcn@sgi.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Alan Mayer <ajm@sgi.com>,
       jeremy@goop.org, rusty@rustcorp.com.au, suresh.b.siddha@intel.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <Yinghai.lu@amd.com>
Subject: Re: [PATCH] x86, UV: add uv_setup_irq() and uv_teardown_irq()
	functions v.3
Message-ID: <20081003085943.GC27551@elte.hu>
References: <20081001114415.GA3281@sgi.com> <86802c440810020919p4391cbebva0eaa5591e7915be@mail.gmail.com> <48E4FA53.7050401@zytor.com> <20081002171821.GA31601@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081002171821.GA31601@sgi.com>
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


* Dean Nelson <dcn@sgi.com> wrote:

> Provide a means for UV interrupt MMRs to be setup with the message to be sent
> when an MSI is raised.
> 
> Signed-off-by: Dean Nelson <dcn@sgi.com>

v3 looks good - applied to tip/x86/uv, thanks Dean!

changed one small detail:

> +EXPORT_SYMBOL(uv_setup_irq);

changed that to a _GPL export. This is rather lowlevel functionality.

	Ingo
