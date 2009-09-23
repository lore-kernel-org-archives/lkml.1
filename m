Return-Path: <linux-kernel-owner+w=401wt.eu-S1752650AbZIWVGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbZIWVGM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 17:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbZIWVGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 17:06:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53005 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbZIWVGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 17:06:11 -0400
Date: Wed, 23 Sep 2009 23:05:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jason Wessel <jason.wessel@windriver.com>, Len Brown <lenb@kernel.org>
Cc: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [origin tree boot hang] [PATCH] Revert "early_printk: Allow
	morethan one early console"
Message-ID: <20090923210555.GA13492@elte.hu>
References: <20090923135539.GA6542@kroah.com> <20090923173709.GA18056@elte.hu> <4ABA6182.1000106@windriver.com> <20090923190239.GC24251@elte.hu> <20090923191756.GA25163@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090923191756.GA25163@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0010]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:


> The commit point to which the attached config and bootlog belongs is:
> 
>   2.6.31-07863-gb64ada6
> 
> Reverting:
> 
>   c953094: early_printk: Allow more than one early console
> 
> solves it.

btw., the boot options are:

Command line: root=/dev/sda6 earlyprintk=serial,ttyS0,115200 console=ttyS0,115200 debug
initcall_debug apic=verbose sysrq_always_enabled ignore_loglevel 
selinux=0 nmi_watchdog=0 panic=1 3

So it's nothing out of the ordinary - typical early-printk use: handover 
from earlyprintk serial console to the real serial console.

	Ingo
