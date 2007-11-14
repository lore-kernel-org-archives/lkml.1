Return-Path: <linux-kernel-owner+w=401wt.eu-S1756848AbXKNBdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbXKNBdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 20:33:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbXKNBdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 20:33:47 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60426
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753159AbXKNBdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 20:33:47 -0500
Date: Tue, 13 Nov 2007 17:33:46 -0800 (PST)
Message-Id: <20071113.173346.100252448.davem@davemloft.net>
To: clameter@sgi.com
Cc: dada1@cosmosbay.com, akpm@linux-foundation.org, linux-mm@vger.kernel.org,
       linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com
Subject: Re: [patch 01/28] cpu alloc: The allocator
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0711131400050.3714@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711131339240.3714@schroedinger.engr.sgi.com>
	<473A1DEA.7000307@cosmosbay.com>
	<Pine.LNX.4.64.0711131400050.3714@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Tue, 13 Nov 2007 14:00:45 -0800 (PST)

> On Tue, 13 Nov 2007, Eric Dumazet wrote:
> 
> > Once you add in mm/vmalloc.c all needed helpers, no need to use BSS Megablob
> > anymore ?
> 
> Well I think all of this can be avoided by simply copying the existing 
> vmemmap helper functions and providing a virtual address for sparc64.

I intend to do that in the end, but you miss my point.
Requiring this is unreasonable.

And nobody is going to do the virt stuff for platforms like sparc32.
And I do mean nobody.
