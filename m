Return-Path: <linux-kernel-owner+w=401wt.eu-S969446AbXEIBzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969446AbXEIBzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 21:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967846AbXEIBzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 21:55:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47053
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S967364AbXEIBzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 21:55:39 -0400
Date: Tue, 08 May 2007 18:55:39 -0700 (PDT)
Message-Id: <20070508.185539.95059076.davem@davemloft.net>
To: clameter@sgi.com
Cc: mpm@selenic.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: +
 fix-spellings-of-slab-allocator-section-in-init-kconfig.patch added to -mm
 tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0705081852310.17784@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0705081828300.17376@schroedinger.engr.sgi.com>
	<20070508.185141.85412154.davem@davemloft.net>
	<Pine.LNX.4.64.0705081852310.17784@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Tue, 8 May 2007 18:53:28 -0700 (PDT)

> On Tue, 8 May 2007, David Miller wrote:
> 
> > SLOB seems to look at the descriptor in the previous blob to figure
> > out how big the being-freed blob is.  That's actually kind of clever
> > :-)
> 
> We were assuming that the objects are actually allocated. How does it 
> figure out the previous blobs boundaries without metadata?

The page is filled entirely with descriptors in the not-in-use regions
of the page aparently.  So "freed_object - 1" will always give you
a descriptor.

I'm just reading over the code to figure out what to type to you, you
could read the code too it's not very complicated :-)
