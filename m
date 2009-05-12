Return-Path: <linux-kernel-owner+w=401wt.eu-S1760673AbZELLWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760673AbZELLWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 07:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759929AbZELLWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 07:22:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51167 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760194AbZELLWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 07:22:33 -0400
Date: Tue, 12 May 2009 13:22:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, gorcunov@openvz.org, tglx@linutronix.de,
       eswierk@aristanetworks.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/numa] x86: read apic ID in the !acpi_lapic case
Message-ID: <20090512112205.GA12108@elte.hu>
References: <49FC85A9.2070702@kernel.org> <tip-4797f6b021a3fa399942245d07a1feb30df81bb8@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tip-4797f6b021a3fa399942245d07a1feb30df81bb8@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


this build bug is still unfixed:

drivers/pci/hotplug/ibmphp_core.c:165: error: expected identifier before ‘&’ token
drivers/pci/hotplug/ibmphp_core.c:166: error: too few arguments to function ‘IO_APIC_get_PCI_irq_vector’

	Ingo
