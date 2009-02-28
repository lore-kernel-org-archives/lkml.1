Return-Path: <linux-kernel-owner+w=401wt.eu-S1754595AbZB1SXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbZB1SXv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 13:23:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbZB1SXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 13:23:42 -0500
Received: from kroah.org ([198.145.64.141]:38590 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753193AbZB1SXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 13:23:41 -0500
Date: Sat, 28 Feb 2009 10:23:13 -0800
From: Greg KH <greg@kroah.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-mips@linux-mips.org,
       x86@kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       sparclinux@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       stable@kernel.org
Subject: Re: [stable] [PATCH 2/2] x86-64: seccomp: fix 32/64 syscall hole
Message-ID: <20090228182313.GA28421@kroah.com>
References: <20090228030226.C0D34FC3DA@magilla.sf.frob.com> <20090228030413.5B915FC3DA@magilla.sf.frob.com> <alpine.LFD.2.00.0902271932520.3111@localhost.localdomain> <alpine.LFD.2.00.0902271948570.3111@localhost.localdomain> <20090228072554.CFEA6FC3DA@magilla.sf.frob.com> <alpine.LFD.2.00.0902280916470.3111@localhost.localdomain> <20090228174601.GB27607@kroah.com> <20090228095433.6af07a89@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090228095433.6af07a89@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 28, 2009 at 09:54:33AM -0800, Arjan van de Ven wrote:
> On Sat, 28 Feb 2009 09:46:01 -0800
> Greg KH <greg@kroah.com> wrote:
> 
> > On Sat, Feb 28, 2009 at 09:23:36AM -0800, Linus Torvalds wrote:
> > > On Fri, 27 Feb 2009, Roland McGrath wrote:
> > > > But here is the patch you asked for.
> > > 
> > > Yes, this looks much more straightforward. 
> > > 
> > > And I guess the seccomp interaction means that this is potentially
> > > a 2.6.29 thing. Not that I know whether anybody actually _uses_
> > > seccomp. It does seem to be enabled in at least Fedora kernels, but
> > > it might not be used anywhere.
> > 
> > It's enabled in SuSE kernels.
> > 
> 
> but are there users of it?
> I thought Andrea stopped the cpushare thing that was the only user of
> this....

I do not really know, but as it is enabled, we need to at least fix it.

thanks,

greg k-h
