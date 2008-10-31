Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbYJaIwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbYJaIwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 04:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbYJaIwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 04:52:25 -0400
Received: from styx.suse.cz ([82.119.242.94]:59729 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752951AbYJaIwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 04:52:24 -0400
Subject: Re: [PATCH V2 0/2] enable irqs when waiting for rwlocks
From: Petr Tesarik <ptesarik@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: linux-ia64@vger.kernel.org
In-Reply-To: <1224777451.11530.52.camel@elijah.suse.cz>
References: <1224777451.11530.52.camel@elijah.suse.cz>
Content-Type: text/plain
Organization: SUSE LINUX
Date: Fri, 31 Oct 2008 09:52:22 +0100
Message-Id: <1225443142.6825.4.camel@elijah.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-23 at 18:08 +0200, Petr Tesarik wrote:
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
> Petr Tesarik

Any comments on my second patch series? Not even an Acked-by? Dislike of
the concept? Should I post it again?

I feel a bit too uncertain what the status is...

Petr

