Return-Path: <linux-kernel-owner+w=401wt.eu-S1761287AbYDUNwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761287AbYDUNwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753158AbYDUNwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:52:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43781 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbYDUNwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:52:38 -0400
Date: Mon, 21 Apr 2008 15:52:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: tglx@linutronix.de, mingo@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 13/15] [X86] standard vm86 irq handler
Message-ID: <20080421135201.GM9554@elte.hu>
References: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com> <ff3fae70ff950602df4271d8f4a6e36a85421e58.1208559659.git.jgarzik@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff3fae70ff950602df4271d8f4a6e36a85421e58.1208559659.git.jgarzik@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0079]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Garzik <jeff@garzik.org> wrote:

> Prefer 'void *dev_id' argument for passing data from request_irq() to 
> each per-irq handler invocation.

thanks, applied.

> This change's main purpose is to prepare for the patchset in 
> jgarzik/misc-2.6.git#irq-remove, that explores removal of the 
> never-used 'irq' argument in each interrupt handler.

neat ...

	Ingo
