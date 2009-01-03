Return-Path: <linux-kernel-owner+w=401wt.eu-S1760241AbZACWdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760241AbZACWdb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 17:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbZACWdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 17:33:22 -0500
Received: from casper.infradead.org ([85.118.1.10]:36076 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbZACWdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 17:33:22 -0500
Date: Sat, 3 Jan 2009 14:34:55 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] stackprotector re-enabling patches
Message-ID: <20090103143455.4c23d243@infradead.org>
In-Reply-To: <20090103135513.20f14f1d@infradead.org>
References: <20090103214353.GA22949@elte.hu>
	<20090103135513.20f14f1d@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Jan 2009 13:55:13 -0800
Arjan van de Ven <arjan@infradead.org> wrote:

> On Sat, 3 Jan 2009 22:43:53 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> >  
> > diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
> > index 10d6cc3..28f1114 100644
> > --- a/arch/x86/Kconfig.debug
> > +++ b/arch/x86/Kconfig.debug
> > @@ -117,6 +117,7 @@ config DEBUG_RODATA
> >  config DEBUG_RODATA_TEST
> >  	bool "Testcase for the DEBUG_RODATA feature"
> >  	depends on DEBUG_RODATA
> > +	default y
> >  	help
> >  	  This option enables a testcase for the DEBUG_RODATA
> >  	  feature as well as for the change_page_attr()
> 
> I think this chunk isn't meant to be there...

actually never mind.
it does make sense in general (in fact, I'd be tempted to remove the
KConfig for this one and just always do the check)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
