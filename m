Return-Path: <linux-kernel-owner+w=401wt.eu-S935400AbXJSTHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935400AbXJSTHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 15:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763120AbXJSTHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 15:07:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53537 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762699AbXJSTHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 15:07:31 -0400
Date: Fri, 19 Oct 2007 21:07:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jeff Garzik <jeff@garzik.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] Remove 'irq' argument from all irq handlers
Message-ID: <20071019190721.GA1514@elte.hu>
References: <20071019075443.GA6407@havoc.gtf.org> <alpine.LFD.0.9999.0710191649120.22770@localhost.localdomain> <m1bqavgdbf.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1bqavgdbf.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> > thanks for doing this.
> 
> Yes.  keeping this alive is good.
> 
> The practical question is how do we make this change without breaking 
> the drivers that use their irq argument.

the get_irq_regs() approach worked out really well. We should do a 
get_irq_nr() and be done with it?

(Then once the mechanic conversion has been done we could eliminate all 
uses of get_irq_nr() and remove the small overhead it takes to maintain 
this per-cpu value in the irq entry layer.)

full ACK on the concept from me too. Please go ahead! :)

	Ingo
