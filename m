Return-Path: <linux-kernel-owner+w=401wt.eu-S1755752AbZBIXrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbZBIXrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 18:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbZBIXrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 18:47:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45883 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774AbZBIXrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 18:47:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: Re: [Bug #12496] swsusp cannot find resume device (sometimes)
Date: Tue, 10 Feb 2009 00:46:32 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera> <20090208163817.6a53d026@infradead.org> <20090209022700.GA10979@kroah.com>
In-Reply-To: <20090209022700.GA10979@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902100046.33347.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 February 2009, Greg KH wrote:
> On Sun, Feb 08, 2009 at 04:38:17PM -0800, Arjan van de Ven wrote:
> > On Sun,  8 Feb 2009 20:21:39 +0100 (CET)
> > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.28.  Please verify if it still should be listed and let me
> > > know (either way).
> > > 
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12496
> > > Subject		: swsusp cannot find resume device (sometimes)
> > > Submitter	: Rafael J. Wysocki <rjw@sisk.pl>
> > > Date		: 2009-01-09 12:24 (31 days old)
> > > References	:
> > > http://marc.info/?l=linux-kernel&m=123150395731165&w=4
> > > Handled-By	: Arjan van de Ven <arjan@infradead.org>
> > > Patch		:
> > > http://marc.info/?l=linux-kernel&m=123156441218358&w=4
> > > http://marc.info/?t=123156453100002&r=1&w=4
> > > 
> > > 
> > 
> > the patches are in -mm waiting for gregkh to pick them up and push...
> 
> Ok, I'm totally confused now, care to point out exactly which ones I
> should be picking up and pushing?

Patches from -mm called:

drivers-consolidate-driver_probe_done-loops-into-one-place.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
resume-wait-for-device-probing-to-finish.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch

in this order.

Thanks,
Rafael
