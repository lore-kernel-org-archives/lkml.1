Return-Path: <linux-kernel-owner+w=401wt.eu-S1760340AbZF3XXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760340AbZF3XXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbZF3XXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:23:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51768 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320AbZF3XXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:23:37 -0400
Date: Wed, 1 Jul 2009 01:23:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Anton Blanchard <anton@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 8/8] powerpc: Fix PCL vdso detection
Message-ID: <20090630232308.GG17968@elte.hu>
References: <20090630230043.464194676@samba.org> <20090630230141.407009407@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090630230141.407009407@samba.org>
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


* Anton Blanchard <anton@samba.org> wrote:

> PCL uses arch_vma_name() to detect a vdso region which in turn 
> uses current->mm->context.vdso_base. We need to initialise this 
> before doing the mmap or else we fail to detect the vdso.

This too should go via the PowerPC tree i think.

I've applied the rest - nice stuff!!

	Ingo
