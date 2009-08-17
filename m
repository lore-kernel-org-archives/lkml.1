Return-Path: <linux-kernel-owner+w=401wt.eu-S1757443AbZHQJyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbZHQJyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 05:54:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757284AbZHQJyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 05:54:09 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48079 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757278AbZHQJyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 05:54:08 -0400
Subject: Re: [Patch] proc: drop write permission on 'timer_list' and
 'slabinfo'
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Thomas Gleixner <tglx@linutronix.de>, linux-mm@kvack.org,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Matt Mackall <mpm@selenic.com>,
       Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <20090817094822.GA17838@elte.hu>
References: <20090817094525.6355.88682.sendpatchset@localhost.localdomain>
	 <20090817094822.GA17838@elte.hu>
Date: Mon, 17 Aug 2009 12:54:07 +0300
Message-Id: <1250502847.5038.16.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-17 at 11:48 +0200, Ingo Molnar wrote:
> * Amerigo Wang <amwang@redhat.com> wrote:
> 
> > /proc/timer_list and /proc/slabinfo are not supposed to be 
> > written, so there should be no write permissions on it.
> 
> good catch!
> 
> > --- a/kernel/time/timer_list.c
> > +++ b/kernel/time/timer_list.c
> 
> I have applied the timer_list bits to the timer tree. The SLUB/SLAB 
> bits should go into the SLAB tree i guess.

Yeah, I'll grab the slab parts to slab.git if I don't see a separate
patch in my inbox when I get home. Thanks!

			Pekka

