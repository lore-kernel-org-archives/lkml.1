Return-Path: <linux-kernel-owner+w=401wt.eu-S1761468AbYDXTVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761468AbYDXTVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 15:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760712AbYDXTUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 15:20:54 -0400
Received: from ozlabs.org ([203.10.76.45]:35822 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760659AbYDXTUx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 15:20:53 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH] x86: Fix non-kernel use of include/linux/types.h
Date: Fri, 25 Apr 2008 05:20:38 +1000
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Joe Perches <joe@perches.com>
References: <200804250114.38971.rusty@rustcorp.com.au> <20080424160101.GA18854@cs181133002.pp.htv.fi>
In-Reply-To: <20080424160101.GA18854@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804250520.39124.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 April 2008 02:01:01 Adrian Bunk wrote:
> On Fri, Apr 25, 2008 at 01:14:38AM +1000, Rusty Russell wrote:
> > In file included from ../../include/linux/if_tun.h:21,
> >                  from lguest.c:30:
> > ../../include/linux/types.h:203: error: expected specifier-qualifier-list
> > before ‘__kernel_daddr_t’
> >
> > This reversion was created by e40c0fe6b0b5dd16aec3c0dad311d36b19d78fd9
> > 'x86: cleanup duplicate includes' which removed the !__KERNEL__ case from
> > asm-x86/posix_types.h.
>
> I'd actually prefer my patch [1] that:
> - reverts to the 2.6.24 status quo since we shouldn't leak CONFIG_* to
>   userspace at all and
> - also fixes the same regression in unistd.h

Yep, prefer your patch too.

Cheers,
Rusty.
