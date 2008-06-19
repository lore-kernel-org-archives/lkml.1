Return-Path: <linux-kernel-owner+w=401wt.eu-S1758692AbYFSM1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692AbYFSM1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 08:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754831AbYFSM1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 08:27:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53897 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753745AbYFSM1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:27:36 -0400
Date: Thu, 19 Jun 2008 14:27:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] i386: fix vmalloc_sync_all() for Xen
Message-ID: <20080619122718.GI7640@elte.hu>
References: <48591049.76E4.0078.0@novell.com> <485969A4.6090406@goop.org> <485A465D.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <485A465D.76E4.0078.0@novell.com>
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


* Jan Beulich <jbeulich@novell.com> wrote:

> >Given that the usermode PGDs will never need syncing, I think it would 
> >be better to use KERNEL_PGD_PTRS, and define
> >
> >#define sync_index(a) (((a) >> PMD_SHIFT) - KERNEL_PGD_BOUNDARY)
> >
> >for a massive 192 byte saving in bss.
> 
> I was considering that, too, but didn't do so for simplicity's sake. 
> If I'll have to re-spin the patch, I may as well do it.

you could do it as a second add-on patch as well - or as a respun patch. 
Jeremy, is it now Acked-by you?

	Ingo
