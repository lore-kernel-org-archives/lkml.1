Return-Path: <linux-kernel-owner+w=401wt.eu-S1758418AbZF2JPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418AbZF2JPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 05:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbZF2JPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 05:15:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39470 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbZF2JPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 05:15:43 -0400
Date: Mon, 29 Jun 2009 11:15:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Luming Yu <luming.yu@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, suresh.b.siddha@intel.com,
       venkatesh.pallipadi@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC patch] Use IPI_shortcut for lapic timer broadcast
Message-ID: <20090629091528.GB9724@elte.hu>
References: <3877989d0906282347i311eb14bp80a7c80878219c31@mail.gmail.com> <20090629072047.GB20225@elte.hu> <3877989d0906290104q11a767b6qcc1acc4c2d1feba6@mail.gmail.com> <20090629081615.GB571@elte.hu> <3877989d0906290121l15705d2cn72e4c49dd96ed950@mail.gmail.com> <20090629083035.GA4017@elte.hu> <3877989d0906290143y3b5306f4s4a990ecbfbfc49b6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3877989d0906290143y3b5306f4s4a990ecbfbfc49b6@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luming Yu <luming.yu@gmail.com> wrote:

> Please note this is deep-C-state related. C state does add extra 
> latency.. but I don't know how much...

ok, so if each of the CPUs has to be brought out of deep-C and with 
each one 50-100 usecs a pop one could see the total time taking more 
than 1000 usecs. That would explain the hang.

	Ingo
