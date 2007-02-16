Return-Path: <linux-kernel-owner+w=401wt.eu-S1946226AbXBPT0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946226AbXBPT0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 14:26:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946239AbXBPT0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 14:26:37 -0500
Received: from gw.goop.org ([64.81.55.164]:46795 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946226AbXBPT0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 14:26:36 -0500
Message-ID: <45D60569.2050702@goop.org>
Date: Fri, 16 Feb 2007 11:26:33 -0800
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
References: <C1FBB450.99B6%Keir.Fraser@cl.cam.ac.uk>
In-Reply-To: <C1FBB450.99B6%Keir.Fraser@cl.cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Keir Fraser wrote:
> Hmmm... Actually looks like a bunch of architectures do lazy sync of the
> vmalloc area, although neither ia64 nor powerpc does so. However, all
> current users of the alloc_vm_area() function would be okay since none of
> the other lazy-syncing architectures are supported by Xen.
>   

Well, assuming that alloc_vm_area() has some non-Xen use, the right
thing is for archs to export vmalloc_sync_all(), and just use that from
common code.

    J

