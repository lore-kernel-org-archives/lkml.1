Return-Path: <linux-kernel-owner+w=401wt.eu-S1753264AbYCILFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbYCILFq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 07:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbYCILFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 07:05:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37102 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbYCILFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 07:05:36 -0400
Date: Sun, 9 Mar 2008 12:05:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH] signals: print_fatal_signal: fix the signr
	"calculation"
Message-ID: <20080309110511.GA18128@elte.hu>
References: <20080308172453.GA28323@tv-sign.ru> <20080308190311.779B326F990@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080308190311.779B326F990@magilla.localdomain>
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


* Roland McGrath <roland@redhat.com> wrote:

> I'm not sure print-fatal-signals was really ever intended for 
> non-coredump signals.  It doesn't seem like it would be all that 
> useful.  It's probably even undesireable for every normal C-c killing 
> something to cause a printk.

correct. We used to have them for SIGKILL but even that was confusing to 
users - so the intent very much is to only have them for truly 
unexpected, non-user generated and 'fatal', coredump-generating signals.

	Ingo
