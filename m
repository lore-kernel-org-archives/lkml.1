Return-Path: <linux-kernel-owner+w=401wt.eu-S1756378AbZEGAas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378AbZEGAas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 20:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbZEGAaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 20:30:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48023 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbZEGAai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 20:30:38 -0400
Date: Thu, 7 May 2009 02:24:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Roland McGrath <roland@redhat.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
Subject: Re: [PATCH] x86: ptrace debugreg checks rewrite
Message-ID: <20090507002455.GD3756@redhat.com>
References: <20090504001601.GL16631@x200.localdomain> <20090504002431.GA17556@x200.localdomain> <20090506095629.GC15323@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506095629.GC15323@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06, Ingo Molnar wrote:
>
> * Alexey Dobriyan <adobriyan@gmail.com> wrote:
>
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

No, I don't (and couldn't since I don't understand this code ;)

Oleg.

