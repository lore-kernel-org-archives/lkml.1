Return-Path: <linux-kernel-owner+w=401wt.eu-S1759252AbZGCXfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759252AbZGCXfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 19:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754794AbZGCXfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 19:35:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59894 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbZGCXfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 19:35:05 -0400
Date: Sat, 4 Jul 2009 01:35:05 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       "Styner, Douglas W" <douglas.w.styner@intel.com>,
       Chinang Ma <chinang.ma@intel.com>,
       "Prickett, Terry O" <terry.o.prickett@intel.com>,
       Matthew Wilcox <matthew.r.wilcox@intel.com>, Eric.Moore@lsi.com,
       DL-MPTFusionLinux@lsi.com
Subject: Re: >10% performance degradation since 2.6.18
Message-ID: <20090703233505.GL2041@one.firstfloor.org>
References: <20090703025607.GK5480@parisc-linux.org> <87skhdaaub.fsf@basil.nowhere.org> <20090703185414.GP23611@kernel.dk> <20090703191321.GO5480@parisc-linux.org> <20090703192235.GV23611@kernel.dk> <20090703194557.GQ5480@parisc-linux.org> <20090703195458.GK2041@one.firstfloor.org> <20090703130421.646fe5cb@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090703130421.646fe5cb@infradead.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ... so that you can't do power management on a per socket basis?
> hardly a good idea.

Interrupts should only happen when the socket did spent time submitting
the work for them. Typically on drivers I'm familiar with the return
MSI is tied to the CPU that did submit the work item

> just need to use a new enough irqbalance and it will spread out the
> interrupts unless your load is low enough to go into low power mode.

When that load is low then likely you won't get many interrupts
anyways.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
