Return-Path: <linux-kernel-owner+w=401wt.eu-S932846AbXA1VQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846AbXA1VQy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 16:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932866AbXA1VQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 16:16:54 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932846AbXA1VQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 16:16:53 -0500
Date: Sun, 28 Jan 2007 16:16:46 -0500
From: Dave Jones <davej@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Dave Airlie <airlied@gmail.com>, airlied@linux.ie,
       linux-kernel@vger.kernel.org
Subject: Re: gpu sharing layer for kernel
Message-ID: <20070128211646.GC23903@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Greg KH <greg@kroah.com>,
	Dave Airlie <airlied@gmail.com>, airlied@linux.ie,
	linux-kernel@vger.kernel.org
References: <1169637623985-git-send-email-airlied@linux.ie> <20070124214654.GA30634@kroah.com> <21d7e9970701241439y1431254bwf088f9f3043dd0c@mail.gmail.com> <20070125220631.GB5886@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070125220631.GB5886@kroah.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 25, 2007 at 02:06:31PM -0800, Greg Kroah-Hartman wrote:
 > On Thu, Jan 25, 2007 at 09:39:47AM +1100, Dave Airlie wrote:
 > > >> Why do we want this?
 > > >>
 > > >> Currently the kernel cannot provide both the fb and drm drivers with
 > > >> access to the device model and this means the drm cannot get any
 > > >> suspend/resume callbacks.  This layer attempts to fix this problem by
 > > >> adding a bus for the gpu drivers to attach to. Currently a lowlevel
 > > >> binding driver is needed along with optional fb and drm components.
 > > >
 > > >If we were to allow this kind of "sharing" for all PCI devices would
 > > >that work out instead?  Or would this layer still be needed?
 > > 
 > > Initially this layer wouldn't be needed, but I'd like to add some
 > > awareness to the drivers, so the drm can tell the fb to stop doing
 > > stuff and vice-versa if necessary....  but perhaps that could be done
 > > with a generic layer also.. or via the lowlevel driver I have...
 > 
 > Ok, I have no objection to this layer right now, as it solves your
 > problem, and while I would like some time in the future to add such a
 > layer for the PCI devices, it is no where on my todo plate just yet...

It's been bubbling its way up my todo too, as agpgart is starting to
get bug reports due to conflicts when the EDAC drivers or watchdog
drivers 'claim' the south bridge ID before agp gets a chance to init.

Someone sent me some patches a few weeks back, but I seem to have mislaid
them. I'll turf them up and get the sender to send them to lkml.
They should at the least, make a starting point.

		Dave

-- 
http://www.codemonkey.org.uk
