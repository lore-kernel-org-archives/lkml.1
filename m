Return-Path: <linux-kernel-owner+w=401wt.eu-S1759184AbZJPNAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759184AbZJPNAv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 09:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756530AbZJPNAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 09:00:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47688 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756706AbZJPNAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 09:00:49 -0400
Date: Fri, 16 Oct 2009 15:00:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: Re: x86, amd: Get multi-node CPU info from NodeId MSR instead of
	PCI config space
Message-ID: <20091016130000.GC24518@elte.hu>
References: <20091016122229.GB8387@alberich.amd.com> <20091016123853.GA15393@elte.hu> <20091016125700.GD8387@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091016125700.GD8387@alberich.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andreas Herrmann <herrmann.der.user@googlemail.com> wrote:

> > are there any such CPUs?
> 
> Only Magny-Cours so far.
> 
> > I.e. we want to know the effect of this patch on various models of 
> > AMD CPUs - is the change really .32 safe? Does it solve any problem 
> > that makes it .32 material versus being for .33?
> 
> IMHO getting rid of the PCI config space accesses as soon as possible 
> is a benefit, I think.

Agreed.

Is the patch an identity transformation? Or are there CPUs where the 
information from the PCI config space is different from the MSR derived 
one?

	Ingo
