Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbYGYIfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbYGYIfl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 04:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755203AbYGYIfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 04:35:31 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:42477 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbYGYIf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 04:35:29 -0400
Date: Fri, 25 Jul 2008 10:36:01 +0200
From: Sebastien Dugue <sebastien.dugue@bull.net>
To: benh@kernel.crashing.org
Cc: Peter Zijlstra <peterz@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux-rt <linux-rt-users@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Tim Chavez <tinytim@us.ibm.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>,
       Gilles Carry <Gilles.Carry@ext.bull.net>
Subject: Re: [PATCH 2/2][RT] powerpc - Make the irq reverse mapping radix
 tree lockless
Message-ID: <20080725103601.2dbcd7e8@bull.net>
In-Reply-To: <1216974440.11188.100.camel@pasglop>
References: <20080724122352.3bc76bda@bull.net>
	<20080724125044.53b604cb@bull.net>
	<200807242111.35338.nickpiggin@yahoo.com.au>
	<20080724141839.477de30b@bull.net>
	<1216972177.7257.351.camel@twins>
	<1216974440.11188.100.camel@pasglop>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2008 18:27:20 +1000 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Fri, 2008-07-25 at 09:49 +0200, Peter Zijlstra wrote:
> > 
> > 
> > The only advantage of the concurrent radix tree over this model is that
> > it can potentially do multiple modification operations at the same time.
> 
> Yup, we do not need that for the irq revmap... concurrent lookup is all we need.
> 

  Shouldn't we care about concurrent insertion and deletion in the tree? I agree
that concern might be a bit artificial but in theory that can happen.

  Sebastien.
