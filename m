Return-Path: <linux-kernel-owner+w=401wt.eu-S1756633AbXJXKdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633AbXJXKdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 06:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbXJXKdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 06:33:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57596 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501AbXJXKdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 06:33:36 -0400
Date: Wed, 24 Oct 2007 12:33:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH] Bogus KERN_ALERT on oops
Message-ID: <20071024103318.GB18741@elte.hu>
References: <20071022115704.GA6271@localhost.sw.ru> <84144f020710220606o2e52afbfu66a2146c5433d96f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020710220606o2e52afbfu66a2146c5433d96f@mail.gmail.com>
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> > -                       printk(KERN_ALERT "*pde = %016Lx ", page);
> > +                       printk("*pde = %016Lx ", page);
> 
> Use the new KERN_CONT annotation here?

indeed - i changed the patch to do that.

	Ingo
