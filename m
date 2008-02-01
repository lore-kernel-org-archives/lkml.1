Return-Path: <linux-kernel-owner+w=401wt.eu-S932429AbYBANjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429AbYBANjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 08:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718AbYBANjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 08:39:32 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:55499 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754206AbYBANjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 08:39:31 -0500
Date: Fri, 1 Feb 2008 14:39:31 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Holger Wolf <wolf@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] latencytop: Change Kconfig dependency.
Message-ID: <20080201133931.GB13349@uranus.ravnborg.org>
References: <20080201130636.GA29660@osiris.boeblingen.de.ibm.com> <20080201132854.GB13251@uranus.ravnborg.org> <20080201133228.GC11070@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080201133228.GC11070@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 02:32:28PM +0100, Ingo Molnar wrote:
> 
> * Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > >  config STACKTRACE_SUPPORT
> > >  	def_bool y
> > >  
> > > +config HAVE_LATENCYTOP_SUPPORT
> > > +	def_bool y
> > > +
> > No.
> > Please do:
> >  config X86
> > +	select HAVE_LATENCYTOP_SUPPORT
> > 
> > Yes - this is a valid use of select.
> 
> i see - and there's lots of other examples of this and other similar 
> things in other architectures as well. Could we do that as a separate 
> cleanup patch instead, to keep the Kconfig file consistently structured.

I would prefer new stuff to use the recommended method.
But I have no strong feelign for it and at the moment I am fed up
in Section mismatch warnings :-(

	Sam
