Return-Path: <linux-kernel-owner+w=401wt.eu-S1753965AbXDDULQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbXDDULQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 16:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbXDDULP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 16:11:15 -0400
Received: from homer.mvista.com ([63.81.120.158]:64793 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753965AbXDDULO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 16:11:14 -0400
Subject: Re: + clocksource-driver-initialize-list-value.patch added to -mm
	tree
From: Daniel Walker <dwalker@mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tglx@linutronix.de, johnstul@us.ibm.com, mingo@elte.hu,
       LKML <linux-kernel@vger.kernel.org>, heiko.carstens@de.ibm.com
In-Reply-To: <20070404125853.1cf9b7b7.akpm@linux-foundation.org>
References: <200704010523.l315NXJP004063@shell0.pdx.osdl.net>
	 <1175417035.28263.42.camel@localhost.localdomain>
	 <1175704712.15973.35.camel@imap.mvista.com>
	 <20070404125853.1cf9b7b7.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 13:10:25 -0700
Message-Id: <1175717425.15973.61.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 12:58 -0700, Andrew Morton wrote:
> On Wed, 04 Apr 2007 09:38:32 -0700
> Daniel Walker <dwalker@mvista.com> wrote:
> 
> > On Sun, 2007-04-01 at 10:43 +0200, Thomas Gleixner wrote:
> > > On Sat, 2007-03-31 at 22:23 -0700, akpm@linux-foundation.org wrote:
> > > > The patch titled
> > > >      clocksource: driver initialize list value
> > > > has been added to the -mm tree.  Its filename is
> > > >      clocksource-driver-initialize-list-value.patch
> > > > 
> > > > *** Remember to use Documentation/SubmitChecklist when testing your code ***
> > > > 
> > > > See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> > > > out what to do about this
> > > > 
> > > > ------------------------------------------------------
> > > > Subject: clocksource: driver initialize list value
> > > > From: Daniel Walker <dwalker@mvista.com>
> > > > 
> > > > Update drivers/clocksource/ with list initialization.
> > > 
> > > As others pointed out already, can we please have some usefull
> > > description why this change is necessary ? i.e. that it is a preparatory
> > > patch to simplify the clocksource registration logic.
> > > 
> > > 	tglx
> > 
> > I was planning to do it after Andrew release the next -mm then use same
> > patch names he has and just submit to him.. I'm not sure what the
> > easiest method is, and I'd rather like to avoid re-submitting to LKML ..
> 
> Please just send the updated text.  Telling me the name of the patch
> into which it is to be pasted is appreciated.

The following text,

---
The struct clocksource .list field is now required to be initialized
before calling clocksource_register().

This is a prerequisite for simplifying the clocksource
registration process.
---

Goes into ,

clocksource-arm-initialize-list-value.patch
clocksource-avr32-initialize-list-value.patch
clocksource-driver-initialize-list-value.patch
clocksource-i386-initialize-list-value.patch
clocksource-mips-initialize-list-value.patch
clocksource-parisc-initialize-list-value.patch
clocksource-s390-initialize-list-value.patch
clocksource-x86_64-initialize-list-value.patch

The patch names are from 2.6.21-rc5-mm4. Heiko, Thomas do either of you
have any comments on the text being added?

Daniel

