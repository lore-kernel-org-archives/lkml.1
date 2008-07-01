Return-Path: <linux-kernel-owner+w=401wt.eu-S1753618AbYGAGT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618AbYGAGT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 02:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbYGAGTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 02:19:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32877 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbYGAGTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 02:19:16 -0400
Date: Tue, 1 Jul 2008 08:18:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-next@vger.kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mpparse: Add a knob to disable IRQ 0 through I/O
	APIC
Message-ID: <20080701061815.GA16642@elte.hu>
References: <Pine.LNX.4.55.0807010041030.30785@cliff.in.clinika.pl> <20080630215746.84ffb0f4.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080630215746.84ffb0f4.randy.dunlap@oracle.com>
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


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> What calls set_disable_irq0_through_ioapic() ?

a DMI quirk in the next patch:

+dmi_disable_irq0_through_ioapic(const struct dmi_system_id *d)
+{
+       pr_notice("%s detected: disabling IRQ 0 through I/O APIC\n", d->ident);
+       set_disable_irq0_through_ioapic(1);
+       return 0;

	Ingo
