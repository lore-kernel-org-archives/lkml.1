Return-Path: <linux-kernel-owner+w=401wt.eu-S1754374AbYANIu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbYANIu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 03:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbYANIut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 03:50:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55236 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888AbYANIus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 03:50:48 -0500
Date: Mon, 14 Jan 2008 09:50:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: x86: Add the "print code before the trapping instruction"
	feature to 64 bit
Message-ID: <20080114085026.GA26367@elte.hu>
References: <20080110084739.5ba72522@laptopd505.fenrus.org> <4786780F.90302@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4786780F.90302@redhat.com>
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


* Chuck Ebbert <cebbert@redhat.com> wrote:

> > Subject: x86: Add the "print code before the trapping instruction" feature to 64 bit
> > From: Arjan van de Ven <arjan@linux.intel.com>
> > 
> > The 32 bit x86 tree has a very useful feature that prints the Code: 
> > line for the code even before the trapping instrution (and the start 
> > of the trapping instruction is then denoted with a <>). 
> > Unfortunately, the 64 bit x86 tree does not yet have this feature, 
> > making diagnosing backtraces harder than needed.
> > 
> > This patch adds this feature in the same was as the 32 bit tree has 
> > (including the same kernel boot parameter), and including a bugfix 
> > to make the code use probe_kernel_address() rarther than a buggy 
> > (deadlocking) __get_user.
> > 
> 
> If this get accepted I can stop ignoring x86_64 oops reports...

yep - all of Arjan's patches are in x86.git. (right now with a merge 
target of v2.6.25)

	Ingo
