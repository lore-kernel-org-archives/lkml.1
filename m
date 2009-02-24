Return-Path: <linux-kernel-owner+w=401wt.eu-S1755167AbZBXHQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbZBXHQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 02:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbZBXHQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 02:16:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39002 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454AbZBXHQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 02:16:31 -0500
Date: Tue, 24 Feb 2009 08:15:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, "Adam J. Richter" <adam@yggdrasil.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>
Subject: Re: 2.6.29-rc6: Reported regressions from 2.6.28
Message-ID: <20090224071550.GA10436@elte.hu>
References: <GVhknozYwrL.A.hiC.rozoJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <GVhknozYwrL.A.hiC.rozoJB@chimera>
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


(note, the standalone mail of this bug entry did not make it out 
for some reason.)

* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12760
> Subject		: 2.6.29-rc5 hanging at boot when CONFIG_LOCK_STAT=y
> Submitter	: Adam J. Richter <adam@yggdrasil.com>
> Date		: 2009-02-16 6:50 (8 days old)
> References	: http://marc.info/?l=linux-kernel&m=123476768023893&w=4
> Handled-By	: Ingo Molnar <mingo@elte.hu>

Here we came to the conclusion that this is some LILO bug with a 
too large BSS section - that's one thing that CONFIG_LOCK_STAT 
causes. Under Grub the same kernel image boots fine. So unless 
Adam has new data that contradicts this i think we can close 
this bug.

	Ingo
