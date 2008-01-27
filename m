Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbYA0TaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbYA0TaO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 14:30:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbYA0TaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 14:30:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37532 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbYA0T37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 14:29:59 -0500
Date: Sun, 27 Jan 2008 20:29:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Paalanen <pq@iki.fi>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH] x86: Add a list for custom page fault handlers.
Message-ID: <20080127192942.GA12279@elte.hu>
References: <20080127185238.4bcac54b@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080127185238.4bcac54b@daedalus.pq.iki.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0210]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Paalanen <pq@iki.fi> wrote:

>  arch/x86/Kconfig.debug   |    9 ++++++
>  arch/x86/mm/fault_32.c   |   64 ++++++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/mm/fault_64.c   |   64 ++++++++++++++++++++++++++++++++++++++++++++++
>  include/asm-x86/kdebug.h |    9 ++++++

hm, could you please base this against x86.git#mm, see:

    http://redhat.com/~mingo/x86.git/README

thanks,

	Ingo
