Return-Path: <linux-kernel-owner+w=401wt.eu-S1752477AbZBCI1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbZBCI1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 03:27:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751218AbZBCI0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 03:26:53 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37335 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbZBCI0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 03:26:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/3] PCI PM: More refinements of suspend-resume framework
Date: Tue, 3 Feb 2009 09:26:02 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200902012229.27517.rjw@sisk.pl> <200902021032.26819.jbarnes@virtuousgeek.org> <alpine.LFD.2.00.0902021924270.3247@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902021924270.3247@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902030926.03361.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 February 2009, Linus Torvalds wrote:
> 
> On Mon, 2 Feb 2009, Jesse Barnes wrote:
> > >
> > > The last patch makes the warning in pci_legacy_suspend() more useful.
> > 
> > Linus, do you want these as part of the next pull request?  If so, I'll check 
> > them out, pull them in, and let them run the linux-next build gauntlet for a 
> > day before sending them.  Otherwise I'll just send a pull request today with 
> > the 8 or so fixes I have queued now.
> 
> I want them eventually, but I don't know if we got confirmation that this 
> particular series actually fixed the PCI-E bridge issue? The one that 
> Parag reported.. It would be good to have confirmation. Maybe we do 
> already and I missed that email?

An additional patch against the PCIe port driver will be necessary to fix this
issue, but I'm waiting for feedback from Parag about the patches already
posted to find out what's the minimal fix.

Thanks,
Rafael
