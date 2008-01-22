Return-Path: <linux-kernel-owner+w=401wt.eu-S1756795AbYAVMaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbYAVMaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 07:30:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbYAVMaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 07:30:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58376 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbYAVMap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 07:30:45 -0500
Date: Tue, 22 Jan 2008 13:30:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Marcelo Tosatti <marcelo@kvack.org>
Cc: gcosta@redhat.com, ehabkost@redhat.com, glommer@gmail.com, jeremy@goop.org,
       chrisw@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fill in missing pv_mmu_ops entries for
	PAGETABLE_LEVELS >= 3
Message-ID: <20080122123029.GD31253@elte.hu>
References: <12006768251548-git-send-email-gcosta@redhat.com> <20080119181909.GA4640@dmt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080119181909.GA4640@dmt>
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


* Marcelo Tosatti <marcelo@kvack.org> wrote:

> > The first fix is not even specific for PARAVIRT, and it's actually 
> > preventing the whole tree from booting.
> > 
> 
> And the following allows PARAVIRT kernels to boot on x86_64.

> Fill in missing pagetable manipulation entries in pv_mmu_ops 
> for PAGETABLE_LEVELS >= 3.

thanks Marcelo - picked this up and the other changes as well. I guess 
the only thing missing at the moment is the proper Kconfig changes to 
allow the building of a 64-bit PARAVIRT kernel?

	Ingo
