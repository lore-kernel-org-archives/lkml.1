Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbYIAOse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbYIAOse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 10:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbYIAOsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 10:48:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:49696 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbYIAOsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 10:48:22 -0400
Date: Mon, 1 Sep 2008 07:48:18 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>, davej@redhat.com
Subject: Re: [Bug #11438] Upcoming oops in lockdep
Message-ID: <20080901074818.06345dc9@infradead.org>
In-Reply-To: <200809011348.29917.rjw@sisk.pl>
References: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
	<1220132205.8426.40.camel@twins>
	<20080831210115.4fdff99f@infradead.org>
	<200809011348.29917.rjw@sisk.pl>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Sep 2008 13:48:29 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Monday, 1 of September 2008, Arjan van de Ven wrote:
> > On Sat, 30 Aug 2008 23:36:45 +0200
> > Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Sat, 2008-08-30 at 21:50 +0200, Rafael J. Wysocki wrote:
> > > > This message has been generated automatically as a part of a
> > > > report of recent regressions.
> > > > 
> > > > The following bug entry is on the current list of known
> > > > regressions from 2.6.26.  Please verify if it still should be
> > > > listed and let me know (either way).
> > > > 
> > > > 
> > > > Bug-Entry	:
> > > > http://bugzilla.kernel.org/show_bug.cgi?id=11438
> > > > Subject		: Upcoming oops in lockdep
> > > > Submitter	: Arjan van de Ven <arjan@infradead.org>
> > > > Date		: 2008-08-23 20:49 (8 days old)
> > > > References	:
> > > > http://marc.info/?l=linux-kernel&m=121952463613140&w=4
> > > > http://www.kerneloops.org/searchweek.php?search=mark_lock
> > > > Handled-By	: Peter Zijlstra <peterz@infradead.org>
> > > 
> > > as far as I'm concerned this has nothing to do with lockdep
> > > 
> > >
> > 
> > yeah the pattern increasing looks like a fedora special; eg the
> > fedora utrace patches seem to be utter bust. As long as we keep
> > utrace out of mainline we're fine ;-)
> 
> Should I close it, then?

yeah close it for now

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
