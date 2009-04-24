Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbZDXXpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbZDXXpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 19:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbZDXXpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 19:45:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46085 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbZDXXpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 19:45:20 -0400
Date: Sat, 25 Apr 2009 01:45:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: x86@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/hpet: prevent boot hang when hpet=force used on
	old ICH
Message-ID: <20090424234502.GF6403@elte.hu>
References: <alpine.LFD.2.00.0904222223200.21119@localhost.localdomain> <20090423060936.GA1917@elte.hu> <alpine.LFD.2.00.0904231901570.15843@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904231901570.15843@localhost.localdomain>
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


* Len Brown <lenb@kernel.org> wrote:

> Ingo,
> Thanks for the reply.
> 
> But please disregard that patch -- we've cooked up a better one
> that allows ICH4M to continue to use hpet=force, even for clocksource.
> (and it is an ACPI patch rather than an x86 patch:-)

ok.

> However, I'll also send a 2nd patch to stop soliciting more 
> hpet=force users, since technically we shouldn't be encouraging 
> the use of this un-documented and lightly-validated hardware.

agreed - i've applied this patch.

	Ingo
