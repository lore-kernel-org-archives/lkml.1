Return-Path: <linux-kernel-owner+w=401wt.eu-S1752812AbZDXPa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbZDXPa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 11:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbZDXPaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 11:30:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59425 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752109AbZDXPaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 11:30:10 -0400
Date: Fri, 24 Apr 2009 08:23:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Rusty Russell <rusty@rustcorp.com.au>
cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       Christian Borntraeger <borntraeger@de.ibm.com>, stable@kernel.org
Subject: Re: [PATCH] virtio-rng: Remove false BUG for spurious callbacks
In-Reply-To: <200904231642.59939.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.2.00.0904240822410.3101@localhost.localdomain>
References: <200904231642.59939.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 23 Apr 2009, Rusty Russell wrote:
>
> From: Christian Borntraeger <borntraeger@de.ibm.com>
> 
> The virtio-rng drivers checks for spurious callbacks. Since
> callbacks can be implemented via shared interrupts (e.g. PCI) this
> could lead to guest kernel oopses with lots of virtio devices.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---

I really would have liked a sign-off from you too, rusty. I'll take it 
as-is, since it's trivial, but just a note..

		Linus
