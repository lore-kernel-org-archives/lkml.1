Return-Path: <linux-kernel-owner+w=401wt.eu-S1758285AbXFUUN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285AbXFUUN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 16:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756031AbXFUUNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 16:13:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50981 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755760AbXFUUNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 16:13:19 -0400
Date: Thu, 21 Jun 2007 22:12:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Chuck Ebbert <cebbert@redhat.com>,
       Jarek Poplawski <jarkao2@o2.pl>, Miklos Szeredi <miklos@szeredi.hu>,
       chris@atlee.ca, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
Message-ID: <20070621201219.GC22303@elte.hu>
References: <20070620093612.GA1626@ff.dom.local> <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org> <20070621073031.GA683@elte.hu> <alpine.LFD.0.98.0706210845090.3593@woody.linux-foundation.org> <20070621160817.GA22897@elte.hu> <467AAB04.2070409@redhat.com> <alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org> <20070621202917.a2bfbfc7.dada1@cosmosbay.com> <alpine.LFD.0.98.0706211135360.3593@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706211135360.3593@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> (And no, on 32-bit x86, we don't allow more than 128 CPU's. I don't 
> think such an insane machine has ever existed).

and if people _really_ want to boot a large-smp 32-bit kernel on some 
new, tons-of-cpus box, as a workaround they can enable the spinlock 
debugging code, which has no limitation on the number of CPUs supported.

	Ingo
