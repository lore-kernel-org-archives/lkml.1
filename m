Return-Path: <linux-kernel-owner+w=401wt.eu-S1757013AbYIDIGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013AbYIDIGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 04:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756971AbYIDIFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 04:05:09 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:50730 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756959AbYIDIFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 04:05:05 -0400
Date: Thu, 4 Sep 2008 10:04:55 +0200
From: Sebastien Dugue <sebastien.dugue@bull.net>
To: benh@kernel.crashing.org
Cc: dwalker@mvista.com, tinytim@us.ibm.com, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org,
       jean-pierre.dion@bull.net, michael@ellerman.id.au,
       linuxppc-dev@ozlabs.org, paulus@samba.org, gilles.carry@ext.bull.net,
       tglx@linutronix.de
Subject: Re: [PATCH 2/2] powerpc - Make the irq reverse mapping radix tree
 lockless
Message-ID: <20080904100455.5b96cc29@bull.net>
In-Reply-To: <1220515136.4879.70.camel@pasglop>
References: <1218029429-21114-1-git-send-email-sebastien.dugue@bull.net>
	<1218029429-21114-3-git-send-email-sebastien.dugue@bull.net>
	<1219209781.21386.25.camel@pasglop>
	<20080903154105.7dff49db@bull.net>
	<1220496739.4879.20.camel@pasglop>
	<20080904092252.12b3df4a@bull.net>
	<1220513643.4879.68.camel@pasglop>
	<20080904095507.207d1091@bull.net>
	<1220515136.4879.70.camel@pasglop>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Sep 2008 17:58:56 +1000 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> 
> >   There's nothing to 'de-initialize' here, or am I missing something?
> > radix_tree_insert() will return ENOMEM and won't insert anything.
> 
> Forget my comment, just fallback.
> 
> > > Or you can fallback if you don't find, as easy, probably
> > > easier since it shouldn't happen in practice.
> > 
> >   That's what I had in mind.
> 
> Thanks for doing that work !
>

  Will do that way.

  Thanks,

  Sebastien.
