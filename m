Return-Path: <linux-kernel-owner+w=401wt.eu-S1763749AbYEAROx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763749AbYEAROx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 13:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759410AbYEAROo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 13:14:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51320 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758071AbYEAROn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 13:14:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: Some sort corruption of my Thermal Subsystem after suspend to ram
Date: Thu, 1 May 2008 19:14:37 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Len Brown <lenb@kernel.org>, Gabriel C <nix.or.die@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, pavel@suse.cz
References: <4818D9AB.3040402@googlemail.com> <200805011457.51238.rjw@sisk.pl> <20080501130612.GB19922@srcf.ucam.org>
In-Reply-To: <20080501130612.GB19922@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805011914.38511.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 1 of May 2008, Matthew Garrett wrote:
> On Thu, May 01, 2008 at 02:57:49PM +0200, Rafael J. Wysocki wrote:
> > On Thursday, 1 of May 2008, Matthew Garrett wrote:
> > > Perhaps we should be more aggressive about restoring PCI config space if 
> > > there's no driver bound to a device. The alternative in this case would 
> > > seem to be to write a driver for this device that does nothing other 
> > > than handle suspend/resume.
> > 
> > Well, we have default suspend/resume for PCI devices.  They are called for
> > devices that have no drivers bound to them and execute
> > pci_restore_state()/pci_restore_state(), among other things.  Isn't that
> > sufficient?
> 
> That only saves the "standard" registers, not the rest of config space.

Hm, in that case I'd probably opt for writing a special driver for this
particular device.

Thanks,
Rafael
