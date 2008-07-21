Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbYGUPdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbYGUPdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 11:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbYGUPdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 11:33:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46378 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbYGUPdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 11:33:09 -0400
Date: Mon, 21 Jul 2008 17:32:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] x86 updates for v2.6.27, phase #2
Message-ID: <20080721153256.GA13557@elte.hu>
References: <20080721150415.GA19921@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080721150415.GA19921@elte.hu>
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


hm, i just noticed this ugly build warning:

 fs/partitions/efi.c:102:1: warning: "Dprintk" redefined
 In file included from include/asm/smp.h:13,
                 from include/linux/smp.h:28,
                 from include/linux/topology.h:33,
                 from include/linux/mmzone.h:683,
                 from include/linux/gfp.h:4,
                 from include/linux/mm.h:8,
                 from include/linux/pagemap.h:7,
                 from fs/partitions/check.h:1,
                 from fs/partitions/efi.c:95:
 include/asm/apic.h:15:1: warning: this is the location of the previous 
 definition

i'll fix it ... Dprintk in apic.h is historic and ugly. Should i redo 
the tree and the pull request?

	Ingo
