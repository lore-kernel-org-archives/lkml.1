Return-Path: <linux-kernel-owner+w=401wt.eu-S1760863AbYEANGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760863AbYEANGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 09:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754093AbYEANG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 09:06:29 -0400
Received: from mjg.x.mythic-beasts.com ([93.93.128.6]:48799 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754055AbYEANG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 09:06:28 -0400
Date: Thu, 1 May 2008 14:06:12 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, Gabriel C <nix.or.die@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, pavel@suse.cz
Message-ID: <20080501130612.GB19922@srcf.ucam.org>
References: <4818D9AB.3040402@googlemail.com> <200805010157.58607.lenb@kernel.org> <20080501125348.GA19922@srcf.ucam.org> <200805011457.51238.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805011457.51238.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: Some sort corruption of my Thermal Subsystem after suspend to ram
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 02:57:49PM +0200, Rafael J. Wysocki wrote:
> On Thursday, 1 of May 2008, Matthew Garrett wrote:
> > Perhaps we should be more aggressive about restoring PCI config space if 
> > there's no driver bound to a device. The alternative in this case would 
> > seem to be to write a driver for this device that does nothing other 
> > than handle suspend/resume.
> 
> Well, we have default suspend/resume for PCI devices.  They are called for
> devices that have no drivers bound to them and execute
> pci_restore_state()/pci_restore_state(), among other things.  Isn't that
> sufficient?

That only saves the "standard" registers, not the rest of config space.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
