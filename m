Return-Path: <linux-kernel-owner+w=401wt.eu-S932431AbXDEAf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431AbXDEAf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 20:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932433AbXDEAf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 20:35:29 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:20189 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932431AbXDEAf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 20:35:28 -0400
Subject: Re: + clocksource-driver-initialize-list-value.patch added to -mm
	tree
From: Daniel Walker <dwalker@mvista.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       tglx@linutronix.de, johnstul@us.ibm.com,
       LKML <linux-kernel@vger.kernel.org>, heiko.carstens@de.ibm.com
In-Reply-To: <461440C9.8040902@goop.org>
References: <200704010523.l315NXJP004063@shell0.pdx.osdl.net>
	 <1175417035.28263.42.camel@localhost.localdomain>
	 <1175704712.15973.35.camel@imap.mvista.com>
	 <20070404125853.1cf9b7b7.akpm@linux-foundation.org>
	 <1175717425.15973.61.camel@imap.mvista.com>
	 <20070404203647.GA12563@elte.hu>
	 <1175719489.15973.66.camel@imap.mvista.com>
	 <20070404211514.GA18600@elte.hu>
	 <1175722246.15973.78.camel@imap.mvista.com>
	 <20070404213404.GA21742@elte.hu>
	 <1175723954.15973.96.camel@imap.mvista.com>  <46143941.7050702@goop.org>
	 <1175731253.15973.106.camel@imap.mvista.com>  <461440C9.8040902@goop.org>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 17:34:39 -0700
Message-Id: <1175733279.15973.116.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 17:20 -0700, Jeremy Fitzhardinge wrote:
> Daniel Walker wrote:
> > Setting CLOCK_SOURCE_IS_CONTINUOUS is largely administration , do you
> > know what that flag means?
> >   
> 
> Sure, but at least it has something to do with clocks and time.
> 
> > list values and list initialization are hardly internal details , they
> > are commonly used all over the kernel.
> >   
> 
> The fact that a list is used to string together clocksource structures
> is an internal detail of the clock subsystem.  It's annoying that there
> has to be a list head in the clocksource structure, but at least as a
> clocksource implementer I can ignore it, and if it ever gets changed to
> something else I can keep ignoring it.  Your change makes it something
> that gets pointlessly replicated all over the kernel.

It's already been discussed in the past, but the clocksource structure
is already very simple.. Adding a list initializer doesn't change
anything..

Daniel

