Return-Path: <linux-kernel-owner+w=401wt.eu-S932867AbXBXRcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932867AbXBXRcz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 12:32:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933522AbXBXRcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 12:32:55 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45123 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932867AbXBXRcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 12:32:54 -0500
Date: Sat, 24 Feb 2007 09:32:49 -0800 (PST)
From: Christoph Lameter <clameter@engr.sgi.com>
To: David Miller <davem@davemloft.net>
cc: kamezawa.hiroyu@jp.fujitsu.com, andi@firstfloor.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: SLUB: The unqueued Slab allocator
In-Reply-To: <20070223.215439.92580943.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0702240931030.3912@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702221040140.2011@schroedinger.engr.sgi.com>
 <20070224142835.4c7a3207.kamezawa.hiroyu@jp.fujitsu.com>
 <Pine.LNX.4.64.0702232145340.1872@schroedinger.engr.sgi.com>
 <20070223.215439.92580943.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Feb 2007, David Miller wrote:

> > The general caches already merge lots of users depending on their sizes. 
> > So we already have the situation and we have tools to deal with it.
> 
> But this doesn't happen for things like biovecs, and that will
> make debugging painful.
> 
> If a crash happens because of a corrupted biovec-256 I want to know
> it was a biovec not some anonymous clone of kmalloc256.
> 
> Please provide at a minimum a way to turn the merging off.

Ok. Its currently a compile time option. Will make it possible to specify 
a boot option.
 
> I also agree with Andi in that merging could mess up how object type
> local lifetimes help reduce fragmentation in object pools.

If that is a problem for particular object pools then we may be able to 
except those from the merging.

