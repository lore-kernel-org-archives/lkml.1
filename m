Return-Path: <linux-kernel-owner+w=401wt.eu-S1757360AbXD0Vuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbXD0Vuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 17:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757358AbXD0Vuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 17:50:50 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:55031 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757360AbXD0Vup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 17:50:45 -0400
Date: Sat, 28 Apr 2007 03:19:25 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 2/2] Introduce freezer flags
Message-ID: <20070427214925.GB21224@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <200704271737.31192.rjw@sisk.pl> <200704271740.17972.rjw@sisk.pl> <20070427214047.GA21224@in.ibm.com> <200704272349.36736.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704272349.36736.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 11:49:35PM +0200, Rafael J. Wysocki wrote:
> > > -
> > > +#ifdef CONFIG_FREEZER
> > > +	/* Used by the process freezer, defined in freezer.h */
> > > +	unsigned int freezer_flags;
> > 
> > unsigned long freezer_flags; ??
> 
> I guess so.
> 
> > Else it throws the following warnings.
> 
> On which arch is that?  I've tested on x86_64 ...

I compile tested it on i386 with gcc v4.1.2.

> 
> 
> Greetings,
> Rafael

Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
