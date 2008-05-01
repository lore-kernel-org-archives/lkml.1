Return-Path: <linux-kernel-owner+w=401wt.eu-S1760273AbYEAM6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760273AbYEAM6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 08:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755508AbYEAM6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 08:58:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50143 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754506AbYEAM57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 08:57:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: Some sort corruption of my Thermal Subsystem after suspend to ram
Date: Thu, 1 May 2008 14:57:49 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Len Brown <lenb@kernel.org>, Gabriel C <nix.or.die@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, pavel@suse.cz
References: <4818D9AB.3040402@googlemail.com> <200805010157.58607.lenb@kernel.org> <20080501125348.GA19922@srcf.ucam.org>
In-Reply-To: <20080501125348.GA19922@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805011457.51238.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 1 of May 2008, Matthew Garrett wrote:
> On Thu, May 01, 2008 at 01:57:58AM -0400, Len Brown wrote:
> 
> > I'm not aware of a native Linux device driver that talks to this device
> > (nor can I think of a useful purpose for such a driver)
> > So it seems what is in play here is any BIOS code that talks to this device,
> > and Linux's standard PCI config space restore.
> 
> Perhaps we should be more aggressive about restoring PCI config space if 
> there's no driver bound to a device. The alternative in this case would 
> seem to be to write a driver for this device that does nothing other 
> than handle suspend/resume.

Well, we have default suspend/resume for PCI devices.  They are called for
devices that have no drivers bound to them and execute
pci_restore_state()/pci_restore_state(), among other things.  Isn't that
sufficient?

Rafael
