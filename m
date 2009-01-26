Return-Path: <linux-kernel-owner+w=401wt.eu-S1752790AbZAZQse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbZAZQse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 11:48:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbZAZQs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 11:48:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53330 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbZAZQs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 11:48:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/2] consolidate driver_probe_done() loops into one place
Date: Mon, 26 Jan 2009 17:48:05 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <20090109211346.3ccc36e3@infradead.org> <20090125221857.GA18543@kroah.com>
In-Reply-To: <20090125221857.GA18543@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901261748.06465.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 January 2009, Greg KH wrote:
> On Fri, Jan 09, 2009 at 09:13:46PM -0800, Arjan van de Ven wrote:
> > From 11b47973023398ecdb933c442bab120906946762 Mon Sep 17 00:00:00 2001
> > From: Arjan van de Ven <arjan@linux.intel.com>
> > Date: Fri, 9 Jan 2009 21:04:53 -0800
> > Subject: [PATCH] consolidate driver_probe_done() loops into one place
> > 
> > there's a few places that currently loop over driver_probe_done(), and
> > I'm about to add another one. This patch abstracts it into a helper
> > to reduce duplication.
> > 
> > Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> 
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> Do you need me to take this through my tree?  Or is it going through the
> acpi tree?

I've lost the track.

Anyway, it's a part of a two-patch series and I think both are in -mm.

Andrew, do you have them?

Rafael
