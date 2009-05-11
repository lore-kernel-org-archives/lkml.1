Return-Path: <linux-kernel-owner+w=401wt.eu-S1757350AbZEKJH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbZEKJH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 05:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756409AbZEKJGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 05:06:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56085 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755726AbZEKJGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 05:06:34 -0400
Date: Mon, 11 May 2009 11:05:27 +0200
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
Message-ID: <20090511090527.GA20087@elte.hu>
References: <4A01C35C.7060207@kernel.org> <4A01C406.2040303@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A01C406.2040303@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0113]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hm, you broke the build:

drivers/pci/hotplug/ibmphp_core.c: In function ‘ibmphp_init_devno’:
drivers/pci/hotplug/ibmphp_core.c:165: error: expected identifier before ‘&’ token
drivers/pci/hotplug/ibmphp_core.c:166: error: too few arguments to function ‘IO_APIC_get_PCI_irq_vector’

	Ingo
