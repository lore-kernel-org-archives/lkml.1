Return-Path: <linux-kernel-owner+w=401wt.eu-S1759454AbXJXO2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759454AbXJXO2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 10:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbXJXO2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 10:28:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43709 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbXJXO2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 10:28:12 -0400
Date: Wed, 24 Oct 2007 16:27:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Romano Giannetti <romanol@upcomillas.es>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: 2.6.24-rc1 fails with lockup and BUG:
Message-ID: <20071024142759.GA13657@elte.hu>
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org> <1193232344.32208.0.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193232344.32208.0.camel@localhost>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Romano Giannetti <romanol@upcomillas.es> wrote:

> 2.6.23-rc1 fails for me. I have the sensation it is network-related, 
> but I am not sure, so I send this message just to the list. This same 
> failure was present in git-5734-gd85714d, I sent a message to the list 
> but it seems it never arrived. I hope this will pass through. My 
> system is a toshiba satellite A305-S5077, dual core pentium.

could you turn on these in your .config:

  CONFIG_PROVE_LOCKING=y
  CONFIG_DEBUG_LIST=y
  CONFIG_FRAME_POINTER=y
  CONFIG_DEBUG_SLAB=y

and please post the resulting dmesg output - does lockdep notice any 
lockup reason? (your backtrace suggests some mutex stuff so it might as 
well detect it)

	Ingo
