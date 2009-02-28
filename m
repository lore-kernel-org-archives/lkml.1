Return-Path: <linux-kernel-owner+w=401wt.eu-S1755222AbZB1Ry3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbZB1Ry3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 12:54:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbZB1RyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 12:54:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:46392 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbZB1RyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 12:54:20 -0500
Date: Sat, 28 Feb 2009 09:54:33 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-mips@linux-mips.org,
       x86@kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       sparclinux@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       stable@kernel.org
Subject: Re: [stable] [PATCH 2/2] x86-64: seccomp: fix 32/64 syscall hole
Message-ID: <20090228095433.6af07a89@infradead.org>
In-Reply-To: <20090228174601.GB27607@kroah.com>
References: <20090228030226.C0D34FC3DA@magilla.sf.frob.com>
	<20090228030413.5B915FC3DA@magilla.sf.frob.com>
	<alpine.LFD.2.00.0902271932520.3111@localhost.localdomain>
	<alpine.LFD.2.00.0902271948570.3111@localhost.localdomain>
	<20090228072554.CFEA6FC3DA@magilla.sf.frob.com>
	<alpine.LFD.2.00.0902280916470.3111@localhost.localdomain>
	<20090228174601.GB27607@kroah.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Feb 2009 09:46:01 -0800
Greg KH <greg@kroah.com> wrote:

> On Sat, Feb 28, 2009 at 09:23:36AM -0800, Linus Torvalds wrote:
> > On Fri, 27 Feb 2009, Roland McGrath wrote:
> > > But here is the patch you asked for.
> > 
> > Yes, this looks much more straightforward. 
> > 
> > And I guess the seccomp interaction means that this is potentially
> > a 2.6.29 thing. Not that I know whether anybody actually _uses_
> > seccomp. It does seem to be enabled in at least Fedora kernels, but
> > it might not be used anywhere.
> 
> It's enabled in SuSE kernels.
> 

but are there users of it?
I thought Andrea stopped the cpushare thing that was the only user of
this....


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
