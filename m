Return-Path: <linux-kernel-owner+w=401wt.eu-S1946303AbXBPXmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946303AbXBPXmZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 18:42:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946307AbXBPXl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 18:41:56 -0500
Received: from gw.goop.org ([64.81.55.164]:60697 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946303AbXBPXly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 18:41:54 -0500
Message-ID: <45D64141.90307@goop.org>
Date: Fri, 16 Feb 2007 15:41:53 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Keir Fraser <Keir.Fraser@cl.cam.ac.uk>
CC: Keir Fraser <keir@xensource.com>, Ian Pratt <ian.pratt@xensource.com>,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       virtualization@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Beulich <JBeulich@novell.com>, Andi Kleen <ak@muc.de>
Subject: Re: [Xen-devel] Re: [patch 12/21] Xen-paravirt: Allocate and free
 vmalloc areas
References: <C1FBEEF5.2256%Keir.Fraser@cl.cam.ac.uk>
In-Reply-To: <C1FBEEF5.2256%Keir.Fraser@cl.cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Keir Fraser wrote:
> It has no other users right now and get_vm_area_sync() would be a
> better-named and more generically useful function than alloc_vm_area().
I'm thinking "reserve" might be a better term; "get" generally has the
suggestion of a refcount.

> get_vm_area_sync(), partnered with existing remove_vm_area(), just seems
> much smaller and neater than adding four new functions with a more complex
> usage: alloc_vm_area, {lock,unlock}_vm_area, and free_vm_area. Maybe keeping
> free_vm_area() too makes sense as its interface is more neatly symmetrical
> to that of get_vm_area().

I've already killed the lock/unlock functions.  I'll come up with
something for the get/allocate/reserve and free functions.

    J
