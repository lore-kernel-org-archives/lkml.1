Return-Path: <linux-kernel-owner+w=401wt.eu-S1755875AbZBTWpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbZBTWpK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 17:45:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754074AbZBTWo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 17:44:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57685 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060AbZBTWo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 17:44:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFD] Automatic suspend
Date: Fri, 20 Feb 2009 23:44:18 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
References: <Pine.LNX.4.44L0.0902191659020.7953-100000@iolanthe.rowland.org> <200902201146.59944.rjw@sisk.pl> <200902202305.09992.oliver@neukum.org>
In-Reply-To: <200902202305.09992.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902202344.20040.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 February 2009, Oliver Neukum wrote:
> Am Freitag 20 Februar 2009 11:46:55 schrieb Rafael J. Wysocki:
> > On Thursday 19 February 2009, Oliver Neukum wrote:
> > > Am Donnerstag 19 Februar 2009 23:21:46 schrieb Rafael J. Wysocki:
> > > > > That's the whole point behind userspace wakelocks!  They provide a
> > > > > mechanism for userspace to tell the kernel when (as far as userspace
> > >
> > > is
> > >
> > > > > concerned) it is or is not okay to auto-sleep.
> > > >
> > > > Still, one can go further and observe that the user space can in fact
> > > > start automatic suspend by itself whenever it knows it's appropriate
> > > > ...
> > >
> > > User space initiating this is a race condition.
> >
> > Do you mean a race with the other user space processes or with the kernel?
> 
> With the set of runnable processes.There's always a window between
> evaluating the current set of runnable tasks and telling the kernel to sleep.
> IMO the most elegant solution would be a task attribute that would signal
> the kernel that a task should not count as keeping the system busy even
> if it is runnable and trigger the sleep in kernel space.

Please see my last reply to Arve (http://lkml.org/lkml/2009/2/20/182) and tell
me what you think.

Best,
Rafael
