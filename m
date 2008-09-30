Return-Path: <linux-kernel-owner+w=401wt.eu-S1753499AbYI3TOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbYI3TOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 15:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbYI3TOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 15:14:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52695 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739AbYI3TOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 15:14:08 -0400
Date: Tue, 30 Sep 2008 21:13:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Zachary Amsden <zach@vmware.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: [PATCH] x86, Fix broken LDT access in VMI
Message-ID: <20080930191356.GA28057@elte.hu>
References: <1222797732.7330.35.camel@bodhitayantram.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222797732.7330.35.camel@bodhitayantram.eng.vmware.com>
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


* Zachary Amsden <zach@vmware.com> wrote:

> This one took a long time to rear up because LDT usage is not very
> common, but the bug is quite serious.  It got introduced along with
> another bug, already fixed, by 75b8bb3e56ca09a467fbbe5229bc68627f7445be 
> 
> Please apply.  Fix should also be headed for stable tree and backported,
> it is really sadly trivial.  Glauber, Ingo, sorry for the offlist
> posting, somehow the original missed LKML.

> -	vmi_ops.write_idt_entry(dt, entry, ldt_entry[0], ldt_entry[1]);
> +	vmi_ops.write_ldt_entry(dt, entry, ldt_entry[0], ldt_entry[1]);

oops. Applied to tip/x86/urgent, thanks Zachary!

	Ingo
