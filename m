Return-Path: <linux-kernel-owner+w=401wt.eu-S935526AbZDCUjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935526AbZDCUjG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 16:39:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759201AbZDCUiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 16:38:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35923 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759249AbZDCUiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 16:38:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] build fix for generic debug pagealloc
Date: Fri, 3 Apr 2009 22:38:53 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-rjw; KDE/4.2.1; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Akinobu Mita <akinobu.mita@gmail.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <a4423d670904020421k7395e11dwe70d4223cb817e0a@mail.gmail.com> <20090402094522.b29004c8.akpm@linux-foundation.org> <20090403164450.GC3047@elte.hu>
In-Reply-To: <20090403164450.GC3047@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904032238.55438.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 April 2009, Ingo Molnar wrote:
> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > +config DEBUG_PAGEALLOC
> > > +	bool "Debug page memory allocations"
> > > +	depends on DEBUG_KERNEL && ARCH_SUPPORTS_DEBUG_PAGEALLOC
> > > +	depends on !HIBERNATION || !PPC && !SPARC
> > > +	---help---
> > > +	  Unmap pages from the kernel linear mapping after free_pages().
> > > +	  This results in a large slowdown, but helps to find certain types
> > > +	  of memory corruptions.
> > > +
> > 
> > I guess this is why it wasn't discovered in my compile testing.  
> > It's quite regrettable that `make allmodconfig' didn't enable the 
> > feature. That's what allmodconfig is for.
> 
> Hm, i _do_ remember some hibernation magic fix from Rafael, in the 
> area of debugalloc. Many months ago.
> 
> Rafael, is it supposed to work? If yes, i think we should unblock 
> it.

Yes, it is, at least on x86.

ISTR using DEBUG_PAGEALLOC with hibernation quite some time ago already.

Thanks,
Rafael
