Return-Path: <linux-kernel-owner+w=401wt.eu-S1758628AbYEMKCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628AbYEMKCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 06:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbYEMKCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 06:02:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47040 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbYEMKCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 06:02:24 -0400
Date: Tue, 13 May 2008 12:02:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] x86: Move es7000_plat out of mpparse.c
Message-ID: <20080513100214.GA1034@elte.hu>
References: <20080512152434.27570.7396.stgit@thinkpad> <20080513095528.GB24037@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080513095528.GB24037@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


x86.git testing found that this broke the build:

arch/x86/kernel/acpi/boot.c: In function 'mp_register_ioapic':
arch/x86/kernel/acpi/boot.c:896: error: implicit declaration of function 'bad_ioapic'
arch/x86/kernel/acpi/boot.c: In function 'mp_override_legacy_irq':
arch/x86/kernel/acpi/boot.c:959: error: implicit declaration of function 'MP_intsrc_info'

with this config:

  http://redhat.com/~mingo/misc/config-Tue_May_13_11_52_24_CEST_2008.bad

	Ingo
