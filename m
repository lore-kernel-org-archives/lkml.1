Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbYLVNF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbYLVNF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 08:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbYLVNFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 08:05:51 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:53202 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754029AbYLVNFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 08:05:51 -0500
Subject: Re: [PATCH 01/14] kmemleak: Add the base support
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, penberg@cs.helsinki.fi,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
In-Reply-To: <20081219141400.314023db.akpm@linux-foundation.org>
References: <20081219181255.7778.52219.stgit@pc1117.cambridge.arm.com>
	 <20081219181302.7778.15966.stgit@pc1117.cambridge.arm.com>
	 <84144f020812191208x66f26bc9tf087b35b6c90662a@mail.gmail.com>
	 <20081219220255.GJ2351@elte.hu>
	 <20081219141400.314023db.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 22 Dec 2008 13:05:22 +0000
Message-Id: <1229951122.7938.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Dec 2008 13:05:23.0246 (UTC) FILETIME=[F32A74E0:01C96435]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-19 at 14:14 -0800, Andrew Morton wrote:
> On Fri, 19 Dec 2008 23:02:55 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> > * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > > On Fri, Dec 19, 2008 at 8:13 PM, Catalin Marinas
> > > <catalin.marinas@arm.com> wrote:
> > > > This patch adds the base support for the kernel memory leak
> > > > detector. It traces the memory allocation/freeing in a way similar to
> > > > the Boehm's conservative garbage collector, the difference being that
> > > > the unreferenced objects are not freed but only shown in
> > > > /sys/kernel/debug/kmemleak. Enabling this feature introduces an
> > > > overhead to memory allocations.
> > > >
> > > > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > > > Cc: Ingo Molnar <mingo@elte.hu>
> > > > Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> > > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > > Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > 
> > > Looks good to me. I have only reviewed this lightly but all my major 
> > > concerns have been addressed so feel free to add my:
> > > 
> > > Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
> > 
> > Andrew, do you have any principial objections against having this in 
> 
> Nope.
> 
> > v2.6.29?
> 
> That might be a bit harder.  I'll take a look.

Thanks. Whenever you have time, the up to date kmemleak version
(currently based on v2.6.28-rc9) can be pulled from this branch:

	git://linux-arm.org/linux-2.6.git kmemleak

-- 
Catalin

