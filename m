Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbXC3RHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbXC3RHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 13:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbXC3RHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 13:07:42 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:55820 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945AbXC3RHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 13:07:41 -0400
Date: Fri, 30 Mar 2007 10:07:09 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>, Alexey Dobriyan <adobriyan@sw.ru>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm3: fix e1000 compilation
Message-Id: <20070330100709.44127796.randy.dunlap@oracle.com>
In-Reply-To: <20070330100104.9b770cd8.akpm@linux-foundation.org>
References: <20070330085029.GA6556@localhost.sw.ru>
	<460D2108.1080101@intel.com>
	<20070330100104.9b770cd8.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2007 10:01:04 -0700 Andrew Morton wrote:

> On Fri, 30 Mar 2007 07:39:04 -0700 "Kok, Auke" <auke-jan.h.kok@intel.com> wrote:
> 
> > Alexey Dobriyan wrote:
> > >   CC [M]  drivers/net/e1000/e1000_main.o
> > > drivers/net/e1000/e1000_main.c: In function 'e1000_tso':
> > > drivers/net/e1000/e1000_main.c:2968: error: dereferencing pointer to incomplete type
> > > 	...
> > > 
> > 
> > can you send me your config? I'd like to see why nobody here didn't spot this on 
> > any of our tests.
> > 
> 
> test.kernel.org got thoroughly broken by e1000, but Alexey's patch fixed things
> up.

My daily/nightly builds were also broken by it...

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
