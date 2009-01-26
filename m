Return-Path: <linux-kernel-owner+w=401wt.eu-S1754393AbZAZVJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393AbZAZVJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 16:09:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbZAZVIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 16:08:54 -0500
Received: from kroah.org ([198.145.64.141]:46872 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751850AbZAZVIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 16:08:54 -0500
Date: Mon, 26 Jan 2009 11:43:35 -0800
From: Greg KH <greg@kroah.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] consolidate driver_probe_done() loops into one
	place
Message-ID: <20090126194334.GA16651@kroah.com>
References: <20090109211346.3ccc36e3@infradead.org> <200901261748.06465.rjw@sisk.pl> <20090126085907.743d6346.akpm@linux-foundation.org> <200901262018.41028.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901262018.41028.rjw@sisk.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 08:18:40PM +0100, Rafael J. Wysocki wrote:
> On Monday 26 January 2009, Andrew Morton wrote:
> > On Mon, 26 Jan 2009 17:48:05 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > On Sunday 25 January 2009, Greg KH wrote:
> > > > On Fri, Jan 09, 2009 at 09:13:46PM -0800, Arjan van de Ven wrote:
> > > > > From 11b47973023398ecdb933c442bab120906946762 Mon Sep 17 00:00:00 2001
> > > > > From: Arjan van de Ven <arjan@linux.intel.com>
> > > > > Date: Fri, 9 Jan 2009 21:04:53 -0800
> > > > > Subject: [PATCH] consolidate driver_probe_done() loops into one place
> > > > > 
> > > > > there's a few places that currently loop over driver_probe_done(), and
> > > > > I'm about to add another one. This patch abstracts it into a helper
> > > > > to reduce duplication.
> > > > > 
> > > > > Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> > > > 
> > > > Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> > > > 
> > > > Do you need me to take this through my tree?  Or is it going through the
> > > > acpi tree?
> > > 
> > > I've lost the track.
> > > 
> > > Anyway, it's a part of a two-patch series and I think both are in -mm.
> > > 
> > > Andrew, do you have them?
> > > 
> > 
> > I have these:
> > 
> > early-platform-drivers-v2.patch
> > drivers-consolidate-driver_probe_done-loops-into-one-place.patch
> > drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
> > drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
> > resume-wait-for-device-probing-to-finish.patch
> > sysfs-use-standard-magich-for-sysfs.patch
> > 
> > queued up for sending into Greg for his "driver core" tree.
> 
> Thanks!
> 
> Greg, I assume you're going to get them from Andrew shortly.  2-4 definitely
> are .29 material (they fix a regression), the others two I don't know.

They are?  I didn't realize this, sorry.  What regression do they solve?

thanks,

greg k-h
