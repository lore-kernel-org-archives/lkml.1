Return-Path: <linux-kernel-owner+w=401wt.eu-S1753364AbYIYHmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbYIYHmt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 03:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbYIYHml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 03:42:41 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:57992 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbYIYHmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 03:42:40 -0400
Date: Thu, 25 Sep 2008 09:42:31 +0200
From: Sebastien Dugue <sebastien.dugue@bull.net>
To: benh@kernel.crashing.org
Cc: Milton Miller <miltonm@bga.com>, Jan-Bernd Themann <ossthema@de.ibm.com>,
       Christoph Raisch <RAISCH@de.ibm.com>, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH HACK] powerpc: quick hack to get a functional eHEA with
 hardirq preemption
Message-ID: <20080925094231.442a4c75@bull.net>
In-Reply-To: <1222327361.8277.179.camel@pasglop>
References: <200809231743.23828.ossthema@de.ibm.com>
	<20080915100406.342e027a@bull.net>
	<200809240958.m8O9wM7k010996@sullivan.realtime.net>
	<1222251467.8277.73.camel@pasglop>
	<20080924143552.29a14f10@bull.net>
	<1222290917.8277.83.camel@pasglop>
	<20080925091827.29b5087c@bull.net>
	<1222327361.8277.179.camel@pasglop>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2008 17:22:41 +1000 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Thu, 2008-09-25 at 09:18 +0200, Sebastien Dugue wrote:
> > 
> > > Ok, that's the right approach then. It should work. I don't know
> > what
> > > the specific problems with HEA are at this stage.
> > 
> >   Yep, except as it behaves in way that the current -rt fasteoi flow
> > cannot handle.
> 
> We probably need to make a special xics flow handler for -rt that does
> what Milton suggested, ie, bring down the CPU priority right away

  Do you mean creating a custom fasteoi handler into xics.c? Also, it's
not clear to me from looking at the code how you go about changing the
cpu priority.

> and
> only EOI later or something like that, instead of masking/unmasking.
> 
> I don't know what are the other potential issues with the HEA though.

  Don't know either, but that I can test.

  Thanks,

  Sebastien.
