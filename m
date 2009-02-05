Return-Path: <linux-kernel-owner+w=401wt.eu-S1762289AbZBEBtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762289AbZBEBtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:49:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbZBEBtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:49:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49518 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761649AbZBEBtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:49:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 0/7] PCI PM: Fixes and refinements
Date: Thu, 5 Feb 2009 02:48:40 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <200902040154.36018.rjw@sisk.pl> <200902041723.39209.jbarnes@virtuousgeek.org>
In-Reply-To: <200902041723.39209.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902050248.41209.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 February 2009, Jesse Barnes wrote:
> On Tuesday, February 3, 2009 4:54 pm Rafael J. Wysocki wrote:
> > Hi,
> >
> > The following series of patches contains some fixes and refinements of the
> > PCI PM framework.
> >
> > [1/7] fixes the problem that some driverless devices don't like to be power
> > managed and break things if we attempt to do it.
> >
> > [2/7] and [3/7] fix the problem with devices in PCI_UNKNOWN that are
> > mishandled by the new code.
> >
> > [4/7] fixes regression related to PCIe port suspend-resume.
> >
> > [5/7] fixes the bug that bridges (and PCIe ports) are disabled during
> > suspend, althouth they shouldn't be.
> >
> > [6/7] makes pci_restore_standard_config() read the current power state of
> > the device from the device itself after attempting to change it.
> >
> > [7/7] makes the PCI PM core handle devices more carefully (details in the
> > changelog).
> >
> > Please disregard any previous versions of these patches I sent to you.
> 
> Ok, I pushed this series into my for-linus branch.  Aside from the minor 
> issues in 7/7 that I already mentioned on irc things looked fine, and those 
> were really just cleanups anyway.

Thanks a lot!

Rafael
