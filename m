Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab0APM6p (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 07:58:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167Ab0APM6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 07:58:45 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:45103 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab0APM6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 07:58:44 -0500
Date: Sat, 16 Jan 2010 07:57:40 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Sitsofe Wheeler <sitsofe@yahoo.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Yuhong Bao <yuhongbao_386@hotmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: Ubuntu 32-bit, 32-bit PAE, 64-bit Kernel Benchmarks
In-Reply-To: <20100116123313.GA20059@sucs.org>
Message-ID: <alpine.LFD.2.00.1001160753390.5650@localhost>
References: <SNT125-W41CEF6892DBE0B1FD99B4AC3780@phx.gbl> <4B511B12.6010208@zytor.com> <20100116123313.GA20059@sucs.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Jan 2010, Sitsofe Wheeler wrote:

> On Fri, Jan 15, 2010 at 05:49:06PM -0800, H. Peter Anvin wrote:
> > On 12/30/2009 05:29 PM, Yuhong Bao wrote:
> > >
> > > Given that Linus was once talking about the performance penalties of
> > > PAE and HIGHMEM64G, perhaps you'd find these benchmarks done by
> > > Phoronix of interest:
> > > http://www.phoronix.com/scan.php?page=article&item=ubuntu_32_pae
> > >
> >
> > The big difference isn't between HIGHMEM4G (no PAE) and HIGHMEM64G
> > (PAE), it's between HIGHMEM and !HIGHMEM.  That cutoff is ~892 MB
> > for a stock 32-bit kernel.
>
> Thanks for the clarification - I had been wondering about why those
> settings had been benchmarked against each other...
>
> I took a mild interest because I have an EeePC 900 with 1G of RAM.
> The machine can do PAE but my understanding is that this would lead
> to a performance drop (I currently have VMSPLIT_3G so I can use all
> 1G of memory) so I run it without HIGHMEM.

  actually, it's 896M, not 892M, and i believe it's defined in
arch/x86/mm/init_32.c:

#define high_memory (-128UL << 20)
        BUILD_BUG_ON(VMALLOC_START     >= VMALLOC_END);
#undef high_memory

interesting that it's a hardcoded value -- is there reason that wasn't
configurable?  (he asked from a position of total ignorance.)

rday
--


========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
