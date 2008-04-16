Return-Path: <linux-kernel-owner+w=401wt.eu-S1753674AbYDPSjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674AbYDPSjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 14:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbYDPSj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 14:39:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52496 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbYDPSj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 14:39:26 -0400
Date: Wed, 16 Apr 2008 20:38:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       mingo <mingo@redhat.com>, tglx <tglx@linutronix.de>
Subject: Re: [PATCH -next] x86/trace: uses/depends on PCI
Message-ID: <20080416183857.GB3722@elte.hu>
References: <20080416104418.4fb7f1de.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080416104418.4fb7f1de.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0107]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Don't try to build mmiotrace when CONFIG_PCI=n.
> 
> next-20080416/kernel/trace/trace_mmiotrace.c: In function 'mmio_print_pcidev':
> next-20080416/kernel/trace/trace_mmiotrace.c:62: error: implicit declaration of function 'pci_dev_driver'

thanks Randy, applied.

	Ingo
