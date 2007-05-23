Return-Path: <linux-kernel-owner+w=401wt.eu-S1763114AbXEWOrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763114AbXEWOrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 10:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757227AbXEWOrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 10:47:06 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52957 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760681AbXEWOrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 10:47:06 -0400
Date: Wed, 23 May 2007 10:47:04 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pavel Machek <pavel@ucw.cz>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-rc2-mm1
In-Reply-To: <200705231122.30756.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0705231045370.3673-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007, Rafael J. Wysocki wrote:

> On Wednesday, 23 May 2007 09:48, Andrew Morton wrote:
> > On Wed, 23 May 2007 00:42:33 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc2/2.6.22-rc2-mm1/
> > 
> > This is intermittently getting resume-from-RAM failures.  It is not
> > sufficiently repeatable to be able to bisect.
> > 
> > [ 1381.119362] PM: Preparing system for mem sleep
> > [ 2331.798452] Stopping tasks ... 
> > [ 2351.760431] Stopping kernel threads timed out after 20 seconds (2 tasks refusing to freeze):
> > [ 2351.762385]  ksuspend_usbd
> > [ 2351.764374]  khubd
> > [ 2351.766338] Restarting tasks ... done.
> 
> Hmm, that seems to be related to usb-fix-suspend-to-ram.patch (probably one of
> the threads is waiting for a completion by some other thread that has been
> frozen already).

Is it possible to get an Alt-SysRq-T stack trace during those 20 
seconds?  Knowing what those threads are waiting for would be a big 
help.

Alan Stern

