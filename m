Return-Path: <linux-kernel-owner+w=401wt.eu-S1764839AbZDANWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764839AbZDANWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 09:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756983AbZDANWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 09:22:07 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53078 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567AbZDANWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 09:22:06 -0400
Date: Wed, 1 Apr 2009 15:23:40 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       agraf@suse.de, pmullaney@novell.com, pmorreale@novell.com,
       anthony@codemonkey.ws, rusty@rustcorp.com.au, netdev@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
Message-ID: <20090401132340.GT11935@one.firstfloor.org>
References: <20090331184057.28333.77287.stgit@dev.haskins.net> <87ab71monw.fsf@basil.nowhere.org> <49D35825.3050001@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D35825.3050001@novell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 08:03:49AM -0400, Gregory Haskins wrote:
> Andi Kleen wrote:
> > Gregory Haskins <ghaskins@novell.com> writes:
> >
> > What might be useful is if you could expand a bit more on what the high level
> > use cases for this. 
> >
> > Questions that come to mind and that would be good to answer:
> >
> > This seems to be aimed at having multiple VMs talk
> > to each other, but not talk to the rest of the world, correct? 
> > Is that a common use case? 
> >   
> 
> Actually we didn't design specifically for either type of environment. 

But surely you must have some specific use case in mind? Something
that it does better than the various methods that are available
today. Or rather there must be some problem you're trying
to solve. I'm just not sure what that problem exactly is.

> What we *are* trying to address is making an easy way to declare virtual
> resources directly in the kernel so that they can be accessed more
> efficiently.  Contrast that to the way its done today, where the models
> live in, say, qemu userspace.
> 
> So instead of having
> guest->host->qemu::virtio-net->tap->[iptables|bridge], you simply have
> guest->host->[iptables|bridge].  How you make your private network (if

So is the goal more performance or simplicity or what?

> > What would be the use cases for non networking devices?
> >
> > How would the interfaces to the user look like?
> >   
> 
> I am not sure if you are asking about the guests perspective or the
> host-administators perspective.

I was wondering about the host-administrators perspective.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
