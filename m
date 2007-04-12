Return-Path: <linux-kernel-owner+w=401wt.eu-S1030619AbXDLRxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030619AbXDLRxy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 13:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030624AbXDLRxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 13:53:54 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:51500 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030619AbXDLRxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 13:53:53 -0400
Subject: Re: [PATCH] i386 tsc: remove xtime_lock'ing around cpufreq notifier
From: Daniel Walker <dwalker@mvista.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@novell.com>,
       linux-kernel@vger.kernel.org, johnstul@us.ibm.com, tglx@linutronix.de
In-Reply-To: <461E6FA7.5080605@goop.org>
References: <20070411162904.232696302@mvista.com>
	 <200704121136.03098.ak@novell.com>
	 <20070412092348.70a4de05.akpm@linux-foundation.org>
	 <200704121845.39961.ak@novell.com>
	 <20070412100039.00ace23f.akpm@linux-foundation.org>
	 <461E6FA7.5080605@goop.org>
Content-Type: text/plain
Date: Thu, 12 Apr 2007 10:52:46 -0700
Message-Id: <1176400366.20237.54.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-12 at 10:43 -0700, Jeremy Fitzhardinge wrote:
> Andrew Morton wrote:
> > hm.  People (ab)use sched_clock() for all sorts of things nowadays.  I wouldn't
> > do anything to degrade it just on behalf of printk-timestamping.
> >   
> 
> printk was the only non-scheduler-ish use I could find.  Are there others?
> 
>     J

There is some usage in block/blktrace.c (which I've not seen before..)

Daniel

