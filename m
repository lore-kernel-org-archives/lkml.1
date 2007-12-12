Return-Path: <linux-kernel-owner+w=401wt.eu-S1759147AbXLLKZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759147AbXLLKZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 05:25:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755115AbXLLKY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 05:24:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47430 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103AbXLLKY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 05:24:58 -0500
Date: Wed, 12 Dec 2007 11:24:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kevin Hilman <khilman@mvista.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Generic IRQ: Add unlocked version of set_irq_handler()
Message-ID: <20071212102437.GI24246@elte.hu>
References: <1197413651-23076-1-git-send-email-khilman@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197413651-23076-1-git-send-email-khilman@mvista.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kevin Hilman <khilman@mvista.com> wrote:

> Add unlocked version for use by irq_chip.set_type handlers which may 
> wish to change handler to level or edge handler when IRQ type is 
> changed.
> 
> The normal set_irq_handler() call cannot be used because it tries to 
> take irq_desc.lock which is already held when the irq_chip.set_type 
> hook is called.

looks fine to me. Thomas?

	Ingo
