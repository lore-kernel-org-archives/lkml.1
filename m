Return-Path: <linux-kernel-owner+w=401wt.eu-S1758875AbZEFJ5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758875AbZEFJ5n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 05:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbZEFJ5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 05:57:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41877 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710AbZEFJ5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 05:57:33 -0400
Date: Wed, 6 May 2009 11:56:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>, Roland McGrath <roland@redhat.com>,
       Oleg Nesterov <oleg@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
Subject: Re: [PATCH] x86: ptrace debugreg checks rewrite
Message-ID: <20090506095629.GC15323@elte.hu>
References: <20090504001601.GL16631@x200.localdomain> <20090504002431.GA17556@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090504002431.GA17556@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Mon, May 04, 2009 at 04:16:01AM +0400, Alexey Dobriyan wrote:
> > +static int ptrace_check_debugreg(int _32bit,
> > +				 unsigned long dr0, unsigned long dr1,
> > +				 unsigned long dr2, unsigned long dr3,
> > +				 unsigned long dr6, unsigned long dr7)
> > +{
> > +	/* Breakpoint type: 00: --x, 01: -w-, 10: undefined, 11: rw- */
> > +	unsigned int rw[4];
> > +	/* Breakpoint length: 00: 1 byte, 01: 2 bytes, 10: 8 bytes, 11: bytes */
> 								        4 bytes, of course

Roland, Oleg, do you have any pending/planned changes in this area?

	Ingo
