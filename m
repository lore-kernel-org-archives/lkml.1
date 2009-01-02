Return-Path: <linux-kernel-owner+w=401wt.eu-S1759559AbZABTF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759559AbZABTF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 14:05:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758226AbZABTFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 14:05:49 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:60188 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072AbZABTFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 14:05:47 -0500
Subject: Re: [PATCH] kbuild: Disallow GCC 4.1.0 / 4.1.1
From: Detlef Riekenberg <wine.dev@web.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       rdreier@cisco.com, ian.campbell@citrix.com,
       jeremy.fitzhardinge@citrix.com, deller@gmx.de, rusty@rustcorp.com.au,
       linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       kyle@mcmartin.ca, randolph@tausq.org, dave@hiauly1.hia.nrc.ca,
       Dan Kegel <dank@kegel.com>
In-Reply-To: <20090102183353.GF10072@elte.hu>
References: <alpine.LFD.2.00.0812310942110.5086@localhost.localdomain>
	 <20081231105425.9ccac21d.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.0812311318420.5086@localhost.localdomain>
	 <20081231.141408.60544902.davem@davemloft.net>
	 <20090102115547.GB3027@elte.hu>
	 <alpine.LFD.2.00.0901020844070.5086@localhost.localdomain>
	 <alpine.LFD.2.00.0901020933370.5086@localhost.localdomain>
	 <20090102175737.GA5818@uranus.ravnborg.org>
	 <20090102182248.GC10072@elte.hu>
	 <20090102182915.GA6143@uranus.ravnborg.org>
	 <20090102183353.GF10072@elte.hu>
Content-Type: text/plain
Date: Fri, 02 Jan 2009 20:05:44 +0100
Message-Id: <1230923144.5811.11.camel@p4.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+g0pcysavmpFnkQrGcIUAXkzGBg+6hUXS58osE
	SDIXUys8/nOmsSqyMCcbaAD/UZbw6jsBkCiWUm0cpJQlKu8w0Q
	g/mu+qVBE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar wrote:
> * Sam Ravnborg <sam@ravnborg.org> wrote:
 
> > > what type of cross-build breakage do they cause?
> > 
> > The default gcc made by demo-alpha with crosstool is version 4.1.0:
> > 
> >  /opt/crosstool/gcc-4.1.0-glibc-2.3.6/alpha-unknown-linux-gnu/bin/alpha-unknown-linux-gnu-gcc --version
> > alpha-unknown-linux-gnu-gcc (GCC) 4.1.0
> > Copyright (C) 2006 Free Software Foundation, Inc.
> > This is free software; see the source for copying conditions.  There is NO
> > warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> 
> ah, ok. I build cross-compilers from scratch, so i have 4.3.3-pre:
> 
>  phoenix:~/linux/linux> /opt/crossgcc/cross/bin/alpha-linux-gcc -v
>  [...]
>  gcc version 4.3.3 20081123 (prerelease) (GCC) 
> 
> 	Ingo

I forwarded the thread to Dan Kegel to make him aware, that the used gcc
version in crosstools makes problems.


-- 
 
Bye bye ... Detlef



