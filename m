Return-Path: <linux-kernel-owner+w=401wt.eu-S1759476AbYDKNlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759476AbYDKNlj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 09:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbYDKNlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 09:41:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58134 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbYDKNlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 09:41:24 -0400
Subject: Re: [PATCH 1/2] HAVE_SET_RESTORE_SIGMASK
From: David Woodhouse <dwmw2@infradead.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Roland McGrath <roland@redhat.com>,
       "Linus Torvalds <torvalds@linux-foundation.org>Andrew Morton" 
	<akpm@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-s390@vger.kernel.org,
       tony.luck@intel.com, linux-ia64@vger.kernel.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, miles@gnu.org,
       geert@linux-m68k.org, zippel@linux-m68k.org
In-Reply-To: <20080410203250.GA21589@flint.arm.linux.org.uk>
References: <20080329001230.D013726FA1D@magilla.localdomain>
	 <20080329001341.7F93826FA1D@magilla.localdomain>
	 <alpine.LFD.1.00.0803281746480.14670@woody.linux-foundation.org>
	 <20080329022408.0DD4726FA1D@magilla.localdomain>
	 <20080329031146.6FF7126FA1D@magilla.localdomain>
	 <1207741532.27048.64.camel@shinybook.infradead.org>
	 <20080410203250.GA21589@flint.arm.linux.org.uk>
Content-Type: text/plain
Date: Fri, 11 Apr 2008 14:40:34 +0100
Message-Id: <1207921234.22291.4.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-10 at 21:32 +0100, Russell King wrote: 
> On Wed, Apr 09, 2008 at 12:45:32PM +0100, David Woodhouse wrote:
> > On Fri, 2008-03-28 at 20:11 -0700, Roland McGrath wrote:
> > > Change all the #ifdef TIF_RESTORE_SIGMASK conditionals in non-arch
> > > code to #ifdef HAVE_SET_RESTORE_SIGMASK.
> > 
> > That ifdef was only supposed to be a temporary thing until all
> > architectures had implemented TIF_RESTORE_SIGMASK anyway.
> > 
> > It looks like only ARM, v850 and m68k which are still missing it; if
> > those three architectures can catch up, then hopefully it can die off
> > completely quite soon.
> 
> Well, we don't have the pselect/ppoll/epoll_wait syscalls and there's
> been no demand for them, so I don't particularly see the point of
> going to the trouble of adding support for something no one's
> interested in using.

You're not likely to see demand for it from users. I believe glibc will
emulate it as best it can (which is not very well), and things will
appear to work.... most of the time.

-- 
dwmw2

