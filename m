Return-Path: <linux-kernel-owner+w=401wt.eu-S1758646AbYEYKfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646AbYEYKfm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 06:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753317AbYEYKfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 06:35:33 -0400
Received: from ozlabs.org ([203.10.76.45]:50287 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbYEYKfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 06:35:32 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: initialization of static per-cpu variables
Date: Sun, 25 May 2008 20:35:24 +1000
User-Agent: KMail/1.9.9
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
References: <19f34abd0805211128r29fa437fm9e9e4c3d3c196f62@mail.gmail.com> <200805221820.07290.rusty@rustcorp.com.au> <20080523142904.GB28257@cs181133002.pp.htv.fi>
In-Reply-To: <20080523142904.GB28257@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805252035.24535.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 May 2008 00:29:04 Adrian Bunk wrote:
> On Thu, May 22, 2008 at 06:20:06PM +1000, Rusty Russell wrote:
> > Yep, it was an old toolchain used by Sparc: DaveM found this one.  As you
> > say, it's ancient: I'm happy to queue a cleanup patch now everyone is on
> > a modern compiler.
>
> The commit says:
>
>     GCC3.1 apparently gets confused about uninitialized sections
>
> We do still support gcc 3.2 (which is the same as 3.1 except for a C++
> ABI change) as a compiler for the kernel.

Adrian, that's a little silly.  There are obviously bug fixes in 3.2 over 
3.1.0.  Noone has complained about the introduction of multiple other cases 
which would screw things up if they experienced this bug.

Finally, it's a sparc64 problem and DaveM acked already.  That's half the 
userbase!

Cheers,
Rusty.
