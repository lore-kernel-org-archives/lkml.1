Return-Path: <linux-kernel-owner+w=401wt.eu-S1752883AbZAZQ74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbZAZQ74 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 11:59:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbZAZQ7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 11:59:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35082 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751448AbZAZQ7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 11:59:48 -0500
Date: Mon, 26 Jan 2009 08:59:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] consolidate driver_probe_done() loops into one
 place
Message-Id: <20090126085907.743d6346.akpm@linux-foundation.org>
In-Reply-To: <200901261748.06465.rjw@sisk.pl>
References: <20090109211346.3ccc36e3@infradead.org>
	<20090125221857.GA18543@kroah.com>
	<200901261748.06465.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2009 17:48:05 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Sunday 25 January 2009, Greg KH wrote:
> > On Fri, Jan 09, 2009 at 09:13:46PM -0800, Arjan van de Ven wrote:
> > > From 11b47973023398ecdb933c442bab120906946762 Mon Sep 17 00:00:00 2001
> > > From: Arjan van de Ven <arjan@linux.intel.com>
> > > Date: Fri, 9 Jan 2009 21:04:53 -0800
> > > Subject: [PATCH] consolidate driver_probe_done() loops into one place
> > > 
> > > there's a few places that currently loop over driver_probe_done(), and
> > > I'm about to add another one. This patch abstracts it into a helper
> > > to reduce duplication.
> > > 
> > > Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> > 
> > Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > Do you need me to take this through my tree?  Or is it going through the
> > acpi tree?
> 
> I've lost the track.
> 
> Anyway, it's a part of a two-patch series and I think both are in -mm.
> 
> Andrew, do you have them?
> 

I have these:

early-platform-drivers-v2.patch
drivers-consolidate-driver_probe_done-loops-into-one-place.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
resume-wait-for-device-probing-to-finish.patch
sysfs-use-standard-magich-for-sysfs.patch

queued up for sending into Greg for his "driver core" tree.
