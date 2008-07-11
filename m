Return-Path: <linux-kernel-owner+w=401wt.eu-S1757345AbYGKSzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbYGKSzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 14:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbYGKSza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 14:55:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38604 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbYGKSza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 14:55:30 -0400
Date: Fri, 11 Jul 2008 20:55:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Recover timer_ack lost in the merge of the NMI
	watchdog
Message-ID: <20080711185511.GB17203@elte.hu>
References: <Pine.LNX.4.55.0807111936480.31940@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0807111936480.31940@cliff.in.clinika.pl>
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


* Maciej W. Rozycki <macro@linux-mips.org> wrote:

>  In the course of the recent unification of the NMI watchdog an 
> assignment to timer_ack to switch off unnecesary POLL commands to the 
> 8259A in the case of a watchdog failure has been accidentally removed.  
> The statement used to be limited to the 32-bit variation as since the 
> rewrite of the timer code it has been relevant for the 82489DX only.  
> This change brings it back.

i've applied your fixes to tip/x86/core:

 Maciej W. Rozycki (4):
      x86: L-APIC: Set IRQ0 as edge-triggered
      x86: L-APIC: Always fully configure IRQ0
      x86: I/O APIC: Never configure IRQ2
      x86: Recover timer_ack lost in the merge of the NMI watchdog

thanks Maciej,

	Ingo
