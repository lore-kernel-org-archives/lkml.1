Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab0BFJsH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 04:48:07 -0500
Received: from smtp-out.google.com ([216.239.33.17]:62044 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542Ab0BFJsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 04:48:05 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=lfs9iyUqYnV/dfX7sb2/fEndLzWyyYvIR9TjwZGY/ASohXwFKm/p9IVkpErEe3g0g
	MKHKTVQzBJpl52QFuGuJg==
Date: Sat, 6 Feb 2010 01:47:49 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <andi@firstfloor.org>
cc: submit@firstfloor.org, linux-kernel@vger.kernel.org, haicheng.li@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org
Subject: Re: [PATCH] [2/4] SLAB: Set up the l3 lists for the memory of freshly
 added memory
In-Reply-To: <20100206072636.GO29555@one.firstfloor.org>
Message-ID: <alpine.DEB.2.00.1002060147160.17897@chino.kir.corp.google.com>
References: <201002031039.710275915@firstfloor.org> <20100203213913.D5CD4B1620@basil.firstfloor.org> <alpine.DEB.2.00.1002051316300.2376@chino.kir.corp.google.com> <20100206072636.GO29555@one.firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Feb 2010, Andi Kleen wrote:

> > > +static int slab_memory_callback(struct notifier_block *self,
> > > +				unsigned long action, void *arg)
> > > +{
> > > +	struct memory_notify *mn = (struct memory_notify *)arg;
> > 
> > No cast necessary.
> 
> It's standard practice to cast void *.
> 

$ grep -r "struct memory_notify.*=" *
arch/powerpc/platforms/pseries/cmm.c:	struct memory_notify *marg = arg;
drivers/base/node.c:	struct memory_notify *mnb = arg;
drivers/net/ehea/ehea_main.c:	struct memory_notify *arg = data;
mm/ksm.c:	struct memory_notify *mn = arg;
mm/slub.c:	struct memory_notify *marg = arg;
mm/slub.c:	struct memory_notify *marg = arg;
mm/page_cgroup.c:	struct memory_notify *mn = arg;
