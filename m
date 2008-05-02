Return-Path: <linux-kernel-owner+w=401wt.eu-S934792AbYEBNpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934792AbYEBNpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 09:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764236AbYEBNpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 09:45:46 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:56473 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760710AbYEBNpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 09:45:43 -0400
Date: Fri, 2 May 2008 09:43:49 -0400
From: Theodore Tso <tytso@MIT.EDU>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Tom Rini <trini@kernel.crashing.org>, torvalds@linux-foundation.org,
       bunk@kernel.org, venkatesh.pallipadi@intel.com, davem@davemloft.net,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: huge gcc 4.1.{0,1} __weak problem
Message-ID: <20080502134349.GI17365@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Vegard Nossum <vegard.nossum@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tom Rini <trini@kernel.crashing.org>, torvalds@linux-foundation.org,
	bunk@kernel.org, venkatesh.pallipadi@intel.com, davem@davemloft.net,
	mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
	linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
References: <20080430013108.GA18207@linux-os.sc.intel.com> <20080429.212833.192304794.davem@davemloft.net> <924EFEDD5F540B4284297C4DC59F3DEEF7D18E@orsmsx423.amr.corp.intel.com> <20080501215633.GU29330@cs181133002.pp.htv.fi> <20080501152051.4eb4bad3.akpm@linux-foundation.org> <alpine.LFD.1.10.0805011525460.5994@woody.linux-foundation.org> <20080501153349.f4537ec7.akpm@linux-foundation.org> <20080501232447.GF4354@smtp.west.cox.net> <20080501165945.077d34f9.akpm@linux-foundation.org> <19f34abd0805020018i11fb722fg5a4cc180ab5f2856@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0805020018i11fb722fg5a4cc180ab5f2856@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 09:18:10AM +0200, Vegard Nossum wrote:
> though these are largely untested with Linux Kernel. Most of them are
> gcc 3.4.5 (this should in theory compile the kernel correctly), though
> I found an e-mail from Ingo saying that you need the -tls versions for
> stackprotector to work correctly. This might be a good time to ask if
> I should be making gcc 4.1.2s instead. I need to recompile in either
> case.

Out of curiosity, are you using the stock gcc/binutils from the FSF,
or one of the distro toolchains?  When we were investigating which
compiler/toolchain to use for the LSB Sample Implementation, one of
the comments that I got from folks like Eric Troan from rPath and
others was that out-of-the-box compiler/toolchain had so many bugs,
particularly on non-x86 architectures, that they found they were much
better off using a distro-patched/bug-fixed compiler/toolchain and
treating that as the upstream.

There has been some requests to include cross-compilation
functionality into the LSB Build Environment, so I'd be interested in
seeing how your work has been going, and maybe there's some
opportunity to work together.  Is there a mailing list you have for
this project?

						- Ted
