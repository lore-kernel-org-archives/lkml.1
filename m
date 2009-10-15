Return-Path: <linux-kernel-owner+w=401wt.eu-S935323AbZJOT2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935323AbZJOT2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 15:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935295AbZJOT2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 15:28:35 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:36067 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935286AbZJOT2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 15:28:35 -0400
Date: Thu, 15 Oct 2009 21:27:57 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Roland McGrath <roland@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ian Lance Taylor <iant@google.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] x86: linker script syntax nits
Message-ID: <20091015192757.GA11271@merkur.ravnborg.org>
References: <20091014221024.EFA79E2F@magilla.sf.frob.com> <20091015033010.GB10068@merkur.ravnborg.org> <20091015063837.GA11645@elte.hu> <4AD75920.8000303@zytor.com> <20091015182616.DFD875E6@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091015182616.DFD875E6@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 15, 2009 at 11:26:16AM -0700, Roland McGrath wrote:
> > The other -- and somewhat less cantankerous way -- is to use a dummy symbol:
> > 
> > #define LINUX_ASSERT(expr, name, string) name = ASSERT(expr, string)
> > 
> > "name" would have to be unique for each instance.
> 
> I wouldn't like to pollute the symtabs with those useless symbols.
> 
> #define LINUX_ASSERT(expr, string) PROVIDE(_assert_bogon = ASSERT(expr, string))
> 
> works with a recent ld.  I don't know what the problematic old ld versions
> were.  Do you have such on hand to test?
Jean reported binutils 2.14.90.0.6.

See: http://marc.info/?l=linux-kbuild&m=124930110427870&w=2

	Sam
