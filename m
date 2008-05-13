Return-Path: <linux-kernel-owner+w=401wt.eu-S1758367AbYEMMrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758367AbYEMMrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 08:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754742AbYEMMrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 08:47:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34442 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754663AbYEMMrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 08:47:11 -0400
Date: Tue, 13 May 2008 14:46:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Miklos Vajna <vmiklos@frugalware.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 3/3] x86: janitor work in irq.c
Message-ID: <20080513124653.GG14973@elte.hu>
References: <8779a478ff43d6ed589279078d2abbab789a2dc9.1210678238.git.vmiklos@frugalware.org> <3b7c2a481a341e549024f8672f5752332356855a.1210678238.git.vmiklos@frugalware.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b7c2a481a341e549024f8672f5752332356855a.1210678238.git.vmiklos@frugalware.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0395]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Miklos Vajna <vmiklos@frugalware.org> wrote:

> -static int pirq_amd756_get(struct pci_dev *router, struct pci_dev *dev, int pirq)
> +static int pirq_amd756_get(struct pci_dev *router, struct pci_dev *dev,
> +	int pirq)

it's nicer to break these lines the following way:

static int
pirq_amd756_get(struct pci_dev *router, struct pci_dev *dev, int pirq)

	Ingo
