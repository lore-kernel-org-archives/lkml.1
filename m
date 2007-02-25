Return-Path: <linux-kernel-owner+w=401wt.eu-S933610AbXBYAxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933610AbXBYAxN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 19:53:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933615AbXBYAxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 19:53:13 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41345
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933610AbXBYAxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 19:53:12 -0500
Date: Sat, 24 Feb 2007 16:53:11 -0800 (PST)
Message-Id: <20070224.165311.71091931.davem@davemloft.net>
To: clameter@engr.sgi.com
Cc: kamezawa.hiroyu@jp.fujitsu.com, andi@firstfloor.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: SLUB: The unqueued Slab allocator
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0702240931030.3912@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702232145340.1872@schroedinger.engr.sgi.com>
	<20070223.215439.92580943.davem@davemloft.net>
	<Pine.LNX.4.64.0702240931030.3912@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@engr.sgi.com>
Date: Sat, 24 Feb 2007 09:32:49 -0800 (PST)

> On Fri, 23 Feb 2007, David Miller wrote:
> 
> > I also agree with Andi in that merging could mess up how object type
> > local lifetimes help reduce fragmentation in object pools.
> 
> If that is a problem for particular object pools then we may be able to 
> except those from the merging.

If it is a problem, it's going to be a problem "in general"
and not for specific SLAB caches.

I think this is really a very unwise idea.  We have enough
fragmentation problems as it is.
