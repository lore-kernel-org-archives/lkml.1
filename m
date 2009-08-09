Return-Path: <linux-kernel-owner+w=401wt.eu-S1752060AbZHIKoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbZHIKoe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 06:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbZHIKod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 06:44:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55309 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbZHIKoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 06:44:32 -0400
Date: Sun, 9 Aug 2009 12:44:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, jbarnes@virtuousgeek.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/core] pci/intr_remapping: Allocate irq_iommu on node
Message-ID: <20090809104400.GA1087@elte.hu>
References: <4A785C17.3030104@kernel.org> <tip-94fb9a6b49d3a63831c4e752f6f0ab8da0a99eb5@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tip-94fb9a6b49d3a63831c4e752f6f0ab8da0a99eb5@git.kernel.org>
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


* tip-bot for Yinghai Lu <yinghai@kernel.org> wrote:

> Commit-ID:  94fb9a6b49d3a63831c4e752f6f0ab8da0a99eb5
> Gitweb:     http://git.kernel.org/tip/94fb9a6b49d3a63831c4e752f6f0ab8da0a99eb5
> Author:     Yinghai Lu <yinghai@kernel.org>
> AuthorDate: Tue, 4 Aug 2009 09:04:39 -0700
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Sat, 8 Aug 2009 17:07:37 +0200
> 
> pci/intr_remapping: Allocate irq_iommu on node

-tip testing found that this patch broke the x86 build:

drivers/pci/intr_remapping.c: In function ‘alloc_irte’:
drivers/pci/intr_remapping.c:204: error: ‘struct irq_desc’ has no member named ‘node’
drivers/pci/intr_remapping.c: In function ‘set_irte_irq’:
drivers/pci/intr_remapping.c:258: error: ‘struct irq_desc’ has no member named ‘node’

	Ingo
