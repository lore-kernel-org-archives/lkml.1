Return-Path: <linux-kernel-owner+w=401wt.eu-S1762536AbZAGXfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762536AbZAGXfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 18:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755751AbZAGXfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 18:35:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52364 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755316AbZAGXfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 18:35:40 -0500
Date: Wed, 7 Jan 2009 15:35:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: holt@sgi.com
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org, ptesarik@suse.cz,
       tee@sgi.com, holt@sgi.com, peterz@infradead.org, mingo@elte.hu,
       "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [Patch V3 0/3] Enable irqs when waiting for rwlocks
Message-Id: <20090107153520.b91b5956.akpm@linux-foundation.org>
In-Reply-To: <20081104122405.046233722@attica.americas.sgi.com>
References: <20081104122405.046233722@attica.americas.sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Nov 2008 06:24:05 -0600
holt@sgi.com wrote:

> New in V3:
>  * Handle rearrangement of some arch's include/asm directories.
> 
> New in V2:
>  * get rid of ugly #ifdef's in kernel/spinlock.h
>  * convert __raw_{read|write}_lock_flags to an inline func
> 
> SGI has observed that on large systems, interrupts are not serviced for
> a long period of time when waiting for a rwlock. The following patch
> series re-enables irqs while waiting for the lock, resembling the code
> which is already there for spinlocks.
> 
> I only made the ia64 version, because the patch adds some overhead to
> the fast path. I assume there is currently no demand to have this for
> other architectures, because the systems are not so large. Of course,
> the possibility to implement raw_{read|write}_lock_flags for any
> architecture is still there.
> 

I'm not seeing any Tony Luck acks on this work?
