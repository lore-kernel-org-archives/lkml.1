Return-Path: <linux-kernel-owner+w=401wt.eu-S1761698AbZEFUqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761698AbZEFUqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 16:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761426AbZEFUlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 16:41:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761408AbZEFUlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 16:41:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
Subject: Re: [PATCH] x86: ptrace debugreg checks rewrite
In-Reply-To: Ingo Molnar's message of  Wednesday, 6 May 2009 11:56:29 +0200 <20090506095629.GC15323@elte.hu>
References: <20090504001601.GL16631@x200.localdomain>
	<20090504002431.GA17556@x200.localdomain>
	<20090506095629.GC15323@elte.hu>
X-Shopping-List: (1) Pelvic clairvoyant assumptions
   (2) Regimented nutrition bacon
   (3) Fatuous intrusions
   (4) Cadaverous citations
Message-Id: <20090506203852.D9AC9FC39E@magilla.sf.frob.com>
Date: Wed,  6 May 2009 13:38:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Mon, May 04, 2009 at 04:16:01AM +0400, Alexey Dobriyan wrote:
> > > +static int ptrace_check_debugreg(int _32bit,
> > > +				 unsigned long dr0, unsigned long dr1,
> > > +				 unsigned long dr2, unsigned long dr3,
> > > +				 unsigned long dr6, unsigned long dr7)
> > > +{
> > > +	/* Breakpoint type: 00: --x, 01: -w-, 10: undefined, 11: rw- */
> > > +	unsigned int rw[4];
> > > +	/* Breakpoint length: 00: 1 byte, 01: 2 bytes, 10: 8 bytes, 11: bytes */
> > 								        4 bytes, of course
> 
> Roland, Oleg, do you have any pending/planned changes in this area?

I don't.  I expect the only future work on this arch debugreg stuff to be
via the hw_breakpoint work, extending that and/or building new things on it.


Thanks,
Roland
