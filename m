Return-Path: <linux-kernel-owner+w=401wt.eu-S933907AbXKOWDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933907AbXKOWDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 17:03:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932173AbXKOWDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 17:03:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55264
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1765975AbXKOWDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 17:03:06 -0500
Date: Thu, 15 Nov 2007 14:03:05 -0800 (PST)
Message-Id: <20071115.140305.137877909.davem@davemloft.net>
To: clameter@sgi.com
Cc: corbet@lwn.net, andi@firstfloor.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       schwidefsky@de.ibm.com
Subject: Re: [patch 01/28] cpu alloc: The allocator
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0711151045060.28051@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711132023290.7631@schroedinger.engr.sgi.com>
	<20071113.215306.78239549.davem@davemloft.net>
	<Pine.LNX.4.64.0711151045060.28051@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Thu, 15 Nov 2007 10:49:37 -0800 (PST)

> Well there is an LWN article now that also claims that the cpu_alloc 
> patchset requires a large bss space. Sigh. See
> 
> http://lwn.net/Articles/257828/
> 
> Not true! 44 bytes is reasonable.

Well, the first version of the patch set, the one I tested, did
require a lot of BSS space.  And that's the one they are writing
about.

I don't see how you can even remotely claim that LWN's reporting is
inaccurate here.
