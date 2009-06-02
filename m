Return-Path: <linux-kernel-owner+w=401wt.eu-S1754495AbZFBUz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbZFBUz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 16:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbZFBUzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 16:55:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754476AbZFBUzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 16:55:47 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jan Kratochvil <jan.kratochvil@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for 2.6.30] ptrace: revert "ptrace_detach: the wrong wakeup
	breaks the ERESTARTxxx logic"
In-Reply-To: Oleg Nesterov's message of  Tuesday, 2 June 2009 22:39:39 +0200 <20090602203939.GA13939@redhat.com>
References: <20090529103017.D548FFC2BD@magilla.sf.frob.com>
	<20090529125405.GD19812@redhat.com>
	<20090529143049.GA27424@redhat.com>
	<20090530202313.GA12066@host0.dyn.jankratochvil.net>
	<20090530234449.GA31604@redhat.com>
	<20090601014258.E3EA2FC3C7@magilla.sf.frob.com>
	<20090602011318.GA2461@redhat.com>
	<20090602203939.GA13939@redhat.com>
Emacs: the prosecution rests its case.
Message-Id: <20090602205537.E4143FC403@magilla.sf.frob.com>
Date: Tue,  2 Jun 2009 13:55:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>

Indeed the old code was highly suspect and we need more work to fix it.
But this was not a conservative change and it did produce regressions.
It's better to leave old-and-wrong as it was until we have finished
more thorough revamp work.


Thanks,
Roland
