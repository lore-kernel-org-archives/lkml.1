Return-Path: <linux-kernel-owner+w=401wt.eu-S1757238AbZFKPWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238AbZFKPWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 11:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbZFKPWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 11:22:05 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45612 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753559AbZFKPWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 11:22:04 -0400
Date: Thu, 11 Jun 2009 11:22:06 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch update] Re: [linux-pm] Run-time PM idea (was: Re:
 [RFC][PATCH 0/2] PM: Rearrange core suspend code)
In-Reply-To: <200906111706.16848.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0906111120260.3040-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jun 2009, Oliver Neukum wrote:

> Am Donnerstag, 11. Juni 2009 16:52:03 schrieb Alan Stern:
> > > Under this definition all devices behind an inactive link are suspended,
> > > because they can't do any I/O.  Which appears to makes sense, because
> > > their drivers have to be notified before the link is suspended and the
> > > link has to be turned on for the devices to be able to communicate with
> > > the CPU and RAM.
> > >
> > > If this definition is adopted, then it's quite clear that the device can
> > > only be suspended if all of its children are suspended and it's always
> > > necessary to resume the parent of a device in order to resume the device
> > > itself.
> >
> > Okay, I'll agree to that.  It should be made clear that a device which
> > is "suspended" according to this definition is not necessarily in a
> > low-power state.  For example, before powering down the link to a disk
> > drive you might want the drive's suspend method to flush the drive's
> > cache, but it wouldn't have to spin the drive down.
> 
> This precludes handling busses that have low power states that are
> left automatically. If such links are stacked the management of acceptable
> latencies cannot be left to the busses.
> An actual example are the link states of USB 3.0

I don't understand.  Can you explain more fully?

Alan Stern

