Return-Path: <linux-kernel-owner+w=401wt.eu-S1946231AbXBPTU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946231AbXBPTU7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 14:20:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946232AbXBPTU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 14:20:59 -0500
Received: from mta2.cl.cam.ac.uk ([128.232.0.14]:51835 "EHLO mta2.cl.cam.ac.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946231AbXBPTU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 14:20:58 -0500
User-Agent: Microsoft-Entourage/11.2.5.060620
Date: Fri, 16 Feb 2007 19:19:44 +0000
Subject: Re: [Xen-devel] Re: [patch 12/21] Xen-paravirt: Allocate and free
 vmalloc areas
From: Keir Fraser <Keir.Fraser@cl.cam.ac.uk>
To: Keir Fraser <keir@xensource.com>, Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ian Pratt <ian.pratt@xensource.com>, <xen-devel@lists.xensource.com>,
       Chris Wright <chrisw@sous-sol.org>, <virtualization@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, Jan Beulich <JBeulich@novell.com>,
       Andi Kleen <ak@muc.de>
Message-ID: <C1FBB450.99B6%Keir.Fraser@cl.cam.ac.uk>
Thread-Topic: [Xen-devel] Re: [patch 12/21] Xen-paravirt: Allocate and
 free vmalloc areas
Thread-Index: AcdR/aFp4CN9q73wEduRUwAX8io7RQAAciQr
In-Reply-To: <C1FBB152.99B0%keir@xensource.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/2/07 19:06, "Keir Fraser" <keir@xensource.com> wrote:

>> I had moved it to mm/vmalloc.c in response to previous review comments
>> (namely, its not Xen specific, so it shouldn't live in the Xen part of
>> the tree).
> 
> Then the call will have to be CONFIG_X86. I hadn't realised powerpc were
> also using lock_vm_area. However I suspect that the x86 issue that those
> functions were written doesn't even exist on powerpc, or any other non-x86
> architecture.

Hmmm... Actually looks like a bunch of architectures do lazy sync of the
vmalloc area, although neither ia64 nor powerpc does so. However, all
current users of the alloc_vm_area() function would be okay since none of
the other lazy-syncing architectures are supported by Xen.

 -- Keir


