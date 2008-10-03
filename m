Return-Path: <linux-kernel-owner+w=401wt.eu-S1755656AbYJCFSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656AbYJCFSc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 01:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbYJCFSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 01:18:09 -0400
Received: from mylar.outflux.net ([69.93.193.226]:46670 "EHLO
	mylar.outflux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbYJCFSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 01:18:08 -0400
Date: Thu, 2 Oct 2008 22:15:43 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jakub Jelinek <jakub@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>, libc-alpha@sourceware.org
Subject: Re: [PATCH] ELF: implement AT_RANDOM for future glibc use
Message-ID: <20081003051543.GQ10632@outflux.net>
References: <20081001201116.GD12527@outflux.net> <48E3EFD6.2010704@redhat.com> <20081001215657.GH12527@outflux.net> <20081001220948.GC32107@sunsite.ms.mff.cuni.cz> <20081001222706.68E7E1544B4@magilla.localdomain> <20081003001616.GN10632@outflux.net> <20081003005258.7FEDE154212@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081003005258.7FEDE154212@magilla.localdomain>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2008 at 05:52:58PM -0700, Roland McGrath wrote:
> I think the safe available AT_* values to use are 25, 26.

Out of curiosity, why are there gaps?  I figure I can include some
comments in that header to explain the gaps for future AT_* creations.

> I would configure the size in bytes.  Ulrich suggested it be 16 bytes on
> both 32-bit and 64-bit machines.

I was trying to make the size compile-time static so I could avoid
kmalloc'ing a buffer for get_random_bytes().  But maybe avoid that isn't
sensible?

As for 16 bytes on both 32bit and 64bit, I was aiming to have 4
pointer-sized random values.  16 works for 32bit, but I was hoping to
have 32 on 64bit.  Perhaps I am over-estimating?

-Kees

-- 
Kees Cook
Ubuntu Security Team
