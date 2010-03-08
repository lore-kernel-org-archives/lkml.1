Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab0CHC6r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 21:58:47 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53704 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab0CHC6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 21:58:40 -0500
Date: Mon, 8 Mar 2010 03:58:35 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: Nick Piggin <npiggin@suse.de>, David Rientjes <rientjes@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Andi Kleen <andi@firstfloor.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, "haicheng.li" <haicheng.li@intel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [patch] slab: add memory hotplug support
Message-ID: <20100308025835.GC20695@one.firstfloor.org>
References: <alpine.DEB.2.00.1002242357450.26099@chino.kir.corp.google.com> <alpine.DEB.2.00.1002251228140.18861@router.home> <20100226114136.GA16335@basil.fritz.box> <alpine.DEB.2.00.1002260904311.6641@router.home> <20100226155755.GE16335@basil.fritz.box> <alpine.DEB.2.00.1002261123520.7719@router.home> <alpine.DEB.2.00.1002261555030.32111@chino.kir.corp.google.com> <alpine.DEB.2.00.1003010224170.26824@chino.kir.corp.google.com> <20100305062002.GV8653@laptop> <c1fb08351003050447w17175bbdy15e1e9bb78c2e40@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1fb08351003050447w17175bbdy15e1e9bb78c2e40@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 02:47:04PM +0200, Anca Emanuel wrote:
> Dumb question: it is possible to hot remove the (bad) memory ? And add
> an good one ?

Not the complete DIMM, but if a specific page containing a stuck
bit or similar can be removed since 2.6.33 yes

In theory you could add new memory replacing that memory if your
hardware and your kernel supports that, but typically that's
not worth it for a few K.

> Where is the detection code for the bad module ?

Part of the code is in the kernel, part in mcelog.
It only works with ECC memory and supported systems ATM (currently
Nehalem class Intel Xeon systems)

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
