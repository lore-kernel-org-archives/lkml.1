Return-Path: <linux-kernel-owner+w=401wt.eu-S1753611AbZKQGGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbZKQGGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 01:06:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbZKQGGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 01:06:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34779 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031AbZKQGGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 01:06:04 -0500
Date: Tue, 17 Nov 2009 07:05:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Justin Mattock <justinmattock@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Bug #14483] Interrupts enabled after irqrouter_resume - iMac9,1
Message-ID: <20091117060554.GC30852@elte.hu>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
 <xXQGFmujPl.A.-yG.OTdALB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xXQGFmujPl.A.-yG.OTdALB@chimera>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14483
> Subject		: Interrupts enabled after irqrouter_resume - iMac9,1
> Submitter	: Justin Mattock <justinmattock@gmail.com>
> Date		: 2009-10-25 19:58 (23 days old)
> References	: http://marc.info/?l=linux-kernel&m=125650070420168&w=4

Looks like a suspend bug, not an irq bug. The new warnings in the 
suspend/resume code might have triggered an old bug in that particular 
driver.

	Ingo
