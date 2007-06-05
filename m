Return-Path: <linux-kernel-owner+w=401wt.eu-S1765869AbXFEU1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765869AbXFEU1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 16:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764906AbXFEU1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 16:27:42 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:59880 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764543AbXFEU1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 16:27:41 -0400
Date: Tue, 5 Jun 2007 13:27:30 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/22] 2.6.22-rc3 perfmon2 : modified powerpc files
Message-ID: <20070605202730.GC11693@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <200705291348.l4TDmVGp019827@frankl.hpl.hp.com> <alpine.DEB.0.99.0706040738530.10505@chino.kir.corp.google.com> <20070605114102.GG10199@frankl.hpl.hp.com> <alpine.DEB.0.99.0706050951420.23578@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.99.0706050951420.23578@chino.kir.corp.google.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David,

On Tue, Jun 05, 2007 at 09:52:19AM -0700, David Rientjes wrote:
> > > > @@ -330,10 +330,22 @@
> > > >  #define __NR_signalfd		305
> > > >  #define __NR_timerfd		306
> > > >  #define __NR_eventfd		307
> > > > +#define __NR_pfm_create_context	308
> > > > +#define __NR_pfm_write_pmcs	(__NR_pfm_create_context+1)
> > > > +#define __NR_pfm_write_pmds	(__NR_pfm_create_context+2)
> > > > +#define __NR_pfm_read_pmds	(__NR_pfm_create_context+3)
> > > > +#define __NR_pfm_load_context	(__NR_pfm_create_context+4)
> > > > +#define __NR_pfm_start		(__NR_pfm_create_context+5)
> > > > +#define __NR_pfm_stop		(__NR_pfm_create_context+6)
> > > > +#define __NR_pfm_restart	(__NR_pfm_create_context+7)
> > > > +#define __NR_pfm_create_evtsets	(__NR_pfm_create_context+8)
> > > > +#define __NR_pfm_getinfo_evtsets (__NR_pfm_create_context+9)
> > > > +#define __NR_pfm_delete_evtsets (__NR_pfm_create_context+10)
> > > > +#define __NR_pfm_unload_context	(__NR_pfm_create_context+11)
> > > >  
> > > >  #ifdef __KERNEL__
> > > >  
> > > > -#define __NR_syscalls		308
> > > > +#define __NR_syscalls		319
> > > >  
> > > 
> > > The highest numbered syscall, __NR_pfm_create_context+11, is 319 and 
> > > __NR_syscalls is set to the same, which is wrong.
> > > 
> > You mean, it is off by one, right? Should be 320, then.
> > 
> 
> Yes, and the same off by one problem exists in your i386 patch that adds 
> the new syscalls as well.

Okay, I have fixed that now for powerpc, i386. Mips and IA-64 were fine.

Thanks.


-- 

-Stephane
