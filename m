Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113AbXLKUag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbXLKUag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 15:30:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbXLKUa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 15:30:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37211 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbXLKUa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 15:30:27 -0500
Date: Tue, 11 Dec 2007 21:29:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>, dor.laor@qumranet.com,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: Performance overhead of get_cycles_sync
Message-ID: <20071211202954.GA27929@elte.hu>
References: <475E8C8B.7070308@qumranet.com> <20071211133738.GA8150@elte.hu> <475E9A92.4030001@qumranet.com> <20071211142717.GA15903@elte.hu> <20071211083513.56c2a385@laptopd505.fenrus.org> <20071211170334.GA30144@elte.hu> <p73abohno0u.fsf@bingen.suse.de> <20071211201930.GB22397@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071211201930.GB22397@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > Which is not on core2 which was the question about. And if it was 
> > turned off it wouldn't use get_cycles_sync() at all.
> 
> it is turned off on core2 too:
> 
>  # cat /sys/devices/system/clocksource/clocksource0/current_clocksource
>  acpi_pm

but you are right that it's not turned off on all core2's, so my patch 
is wrong for them.

	Ingo
