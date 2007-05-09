Return-Path: <linux-kernel-owner+w=401wt.eu-S967364AbXEICDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967364AbXEICDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 22:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966416AbXEICDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 22:03:46 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:27992 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966151AbXEICDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 22:03:45 -0400
Date: Tue, 8 May 2007 19:08:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Rientjes <rientjes@google.com>
Cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Sokolovsky <pmiscml@gmail.com>, linux-kernel@vger.kernel.org,
       jeremy@goop.org
Subject: Re: [PATCH] doc: volatile considered evil
Message-Id: <20070508190800.1334b968.randy.dunlap@oracle.com>
In-Reply-To: <alpine.DEB.0.99.0705081702070.28511@chino.kir.corp.google.com>
References: <516386418.20070501080839@gmail.com>
	<20070430235642.e576e917.akpm@linux-foundation.org>
	<20070508121404.17bd97a6.randy.dunlap@oracle.com>
	<a781481a0705081307r546f8889qecca3db16ea03fb8@mail.gmail.com>
	<20070508163452.8b71f682.randy.dunlap@oracle.com>
	<alpine.DEB.0.99.0705081702070.28511@chino.kir.corp.google.com>
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

On Tue, 8 May 2007 17:06:23 -0700 (PDT) David Rientjes wrote:

> On Tue, 8 May 2007, Randy Dunlap wrote:
> 
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Add information on the problems with the C-language "volatile" keyword
> > and why it should not be used (most of the time).
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > ---
> >  Documentation/volatile-usage.txt |  129 +++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 129 insertions(+)
> > 
> > --- /dev/null
> > +++ linux-2.6.21-git10/Documentation/volatile-usage.txt
> > @@ -0,0 +1,129 @@
> > +***** "volatile" considered useless and evil:  Just Say NO! *****
> > +
> > +Do not use the C-language "volatile" keyword
> > +(extracted from lkml emails from Linus)
> > +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > +
> 
> Again, please change this sweeping introduction to explicitly state that 
> Linus' emails were a criticism of using 'volatile' for objects (he refers 
> to them as "data structures") and can be appropriate for asm constructs.

You haven't replied to my other emails...

"volatile" used on a gcc asm extension is different, granted.
It's not even a C-language "volatile" keyword AFAICT, so it doesn't
apply in this context.


Anyway, how is this slightly modified title?

+***** "volatile" considered useless and evil:  Just Say NO! *****
+
+Do not use the C-language "volatile" keyword on kernel data
+(extracted from lkml emails from Linus)


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
