Return-Path: <linux-kernel-owner+w=401wt.eu-S1765979AbYBUNER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765979AbYBUNER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 08:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757225AbYBUND7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 08:03:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56601 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755564AbYBUND6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 08:03:58 -0500
Date: Thu, 21 Feb 2008 14:03:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] X86: remove WARN_ON if MTRRs are all blank
Message-ID: <20080221130332.GA16152@elte.hu>
References: <1203593558-3391-1-git-send-email-joerg.roedel@amd.com> <20080221115452.GB13948@elte.hu> <20080221124735.GA20053@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080221124735.GA20053@amd.com>
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


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> > >  	if (!highest_pfn) {
> > >  		printk(KERN_WARNING "WARNING: strange, CPU MTRRs all blank?\n");
> > > -		WARN_ON(1);
> > >  		return 0;
> > >  	}
> > 
> > instead of obscuring a possibly useful warning, please instead 
> > detect that it's a KVM guest and skip both the warning and the 
> > backtrace in that case.
> 
> How usefull is the backtrace in that place? I agree that the printk 
> warning may be usefull, but I don't see why the backtrace from the 
> WARN_ON is necessary.

it allows us to collect such things on kerneloops.org for example.

	Ingo
