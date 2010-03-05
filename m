Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab0CEOL1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 09:11:27 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:44798 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab0CEOLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 09:11:25 -0500
Date: Fri, 5 Mar 2010 08:11:00 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Anca Emanuel <anca.emanuel@gmail.com>
cc: Nick Piggin <npiggin@suse.de>, David Rientjes <rientjes@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, "haicheng.li" <haicheng.li@intel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [patch] slab: add memory hotplug support
In-Reply-To: <c1fb08351003050447w17175bbdy15e1e9bb78c2e40@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1003050808390.32229@router.home>
References: <alpine.DEB.2.00.1002240949140.26771@router.home>  <alpine.DEB.2.00.1002242357450.26099@chino.kir.corp.google.com>  <alpine.DEB.2.00.1002251228140.18861@router.home>  <20100226114136.GA16335@basil.fritz.box>  <alpine.DEB.2.00.1002260904311.6641@router.home>
  <20100226155755.GE16335@basil.fritz.box>  <alpine.DEB.2.00.1002261123520.7719@router.home>  <alpine.DEB.2.00.1002261555030.32111@chino.kir.corp.google.com>  <alpine.DEB.2.00.1003010224170.26824@chino.kir.corp.google.com>  <20100305062002.GV8653@laptop>
 <c1fb08351003050447w17175bbdy15e1e9bb78c2e40@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Mar 2010, Anca Emanuel wrote:

> Dumb question: it is possible to hot remove the (bad) memory ? And add
> an good one ?

Under certain conditions this is possible. If the bad memory was modified
then you have a condition that requires termination of all processes that
are using the memory. If its the kernel then you need to reboot.

If the memory contains a page from disk then the memory can be moved
elsewhere.

If you can clean up a whole range like that then its possible to replace
the memory.



