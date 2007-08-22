Return-Path: <linux-kernel-owner+w=401wt.eu-S1760748AbXHVNrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760748AbXHVNrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 09:47:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754581AbXHVNq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 09:46:59 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34062 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbXHVNq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 09:46:58 -0400
Date: Wed, 22 Aug 2007 15:46:56 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Christoph Lameter <clameter@sgi.com>, Andi Kleen <andi@firstfloor.org>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
Message-ID: <20070822134656.GB7539@one.firstfloor.org>
References: <Pine.LNX.4.64.0708211614370.6062@schroedinger.engr.sgi.com> <20070821233938.GD29691@Krystal> <Pine.LNX.4.64.0708211640430.6225@schroedinger.engr.sgi.com> <20070821234702.GE29691@Krystal> <Pine.LNX.4.64.0708211649260.6886@schroedinger.engr.sgi.com> <20070822000323.GG29691@Krystal> <p73fy2cz7bs.fsf@bingen.suse.de> <20070822003834.GB1400@Krystal> <Pine.LNX.4.64.0708211757360.3118@schroedinger.engr.sgi.com> <20070822134532.GA3769@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070822134532.GA3769@Krystal>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 09:45:33AM -0400, Mathieu Desnoyers wrote:
> Measurements on a AMD64 2.0 GHz dual-core
> 
> In this test, we seem to remove 10 cycles from the kmalloc fast path.
> On small allocations, it gives a 14% performance increase. kfree fast
> path also seems to have a 10 cycles improvement.

Looks good. Anything that makes kmalloc faster is good

-Andi
