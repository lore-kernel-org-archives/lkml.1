Return-Path: <linux-kernel-owner+w=401wt.eu-S1760039AbZEGOMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760039AbZEGOMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 10:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbZEGOMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 10:12:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57104 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766AbZEGOMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 10:12:02 -0400
Date: Thu, 7 May 2009 16:10:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 5/7] x86/pci: add 4 more return param in
	IO_APIC_get_PCI_irq_vector
Message-ID: <20090507141058.GH481@elte.hu>
References: <4A01C35C.7060207@kernel.org> <4A01C406.2040303@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A01C406.2040303@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> so prepare those params for pcibios_irq_enable to call setup_io_apic_routing
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/include/asm/hw_irq.h     |    4 +
>  arch/x86/kernel/apic/io_apic.c    |  107 ++++++++++++++++++++------------------
>  arch/x86/pci/irq.c                |   24 +++++++-
>  drivers/pci/hotplug/ibmphp_core.c |   52 +++++++++---------
>  4 files changed, 110 insertions(+), 77 deletions(-)

Hm, didnt Jesse ack this already? If yes then it would be nice to 
have that Acked-by tag line in the changelog.

	Ingo
