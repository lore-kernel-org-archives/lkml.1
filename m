Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbYJFWJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbYJFWJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 18:09:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbYJFWI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 18:08:56 -0400
Received: from smtp.outflux.net ([198.145.64.163]:48735 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392AbYJFWI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 18:08:56 -0400
Date: Mon, 6 Oct 2008 15:07:59 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       Jakub Jelinek <jakub@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       libc-alpha@sourceware.org
Subject: Re: [PATCH] ELF: implement AT_RANDOM for future glibc use
Message-ID: <20081006220759.GM10357@outflux.net>
References: <20081001201116.GD12527@outflux.net> <48E3EFD6.2010704@redhat.com> <20081001215657.GH12527@outflux.net> <20081001220948.GC32107@sunsite.ms.mff.cuni.cz> <20081001222706.68E7E1544B4@magilla.localdomain> <20081003001616.GN10632@outflux.net> <87ej2untze.fsf@basil.nowhere.org> <20081006175038.GF10357@outflux.net> <20081006192641.GI3180@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081006192641.GI3180@one.firstfloor.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2008 at 09:26:41PM +0200, Andi Kleen wrote:
> > We're already using get_random* for stack, heap, and brk.  Also,
> > get_random* uses the nonblocking pool, so this is the same as if userspace
> > had tried to pull bytes out of /dev/urandom, which (as I understand it)
> 
> Yes exactly that's the problem. Think about it: do you really 
> need the same cryptographic strength for your mmap placement
> as you need for your SSL session keys?
> 
> And if you need true entropy for your session keys do you
> still get it when it was all used for low security 
> purposes first?

Off-list I was just shown random32().  If AT_RANDOM used that instead,
would that be acceptable?

-- 
Kees Cook
Ubuntu Security Team
