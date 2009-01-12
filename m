Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbZALMmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbZALMmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 07:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbZALMmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 07:42:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42542 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbZALMmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 07:42:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: Regression 2.6.28-git: suspend/resume failure. git bisected to usb suspend/resume patch
Date: Mon, 12 Jan 2009 13:41:51 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       lkml <linux-kernel@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org
References: <200901111348.46216.borntraeger@de.ibm.com> <200901120103.53390.rjw@sisk.pl>
In-Reply-To: <200901120103.53390.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901121341.51674.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 January 2009, Rafael J. Wysocki wrote:
> On Sunday 11 January 2009, Christian Borntraeger wrote:
> > Hello Alan,
> > 
> > git bisect found this patch 
> > 
> > a0d4922da2e4ccb0973095d8d29f36f6b1b5f703 is first bad commit
> > commit a0d4922da2e4ccb0973095d8d29f36f6b1b5f703
> > Author: Alan Stern <stern@rowland.harvard.edu>
> > Date:   Wed Dec 17 15:06:03 2008 -0500
> > 
> >     USB: fix up suspend and resume for PCI host controllers
> > 
> >     This patch (as1192) rearranges the USB PCI host controller suspend and
> >     resume and resume routines:
> > 
> > 
> > To cause my suspend to ram problem with my Thinkpad T61p.
> > I can confirm that 
> > a81a81a25d3ecdab777abca87c5ddf484056103d works
> > and a0d4922da2e4ccb0973095d8d29f36f6b1b5f703  does not work.
> > 
> > Thing is, 29-rc1 with a0d4922da2e4ccb0973095d8d29f36f6b1b5f703  reverted also 
> > fails with suspend/resume. Seems that there was another problem introduced 
> > after that patch.
> 
> Please try if suspend-resume works for you if you make commit
> fa58d305d9925b01830e535896a7227a868a9e15
> (PCI PM: Add suspend counterpart of pci_reenable_device) the head of your
> tree ('git checkout -b test-branch fa58d305d9925b01830e535896a7227a868a9e15').
> 
> If it does, please check the same for commit
> 571ff7584bb9e05fca0eb79752ae55a46faf3a98
> (PCI PM: Power-manage devices without drivers during suspend-resume).

Ah, please do the above with the USB commit
a0d4922da2e4ccb0973095d8d29f36f6b1b5f703 reverted.

Thanks,
Rafael
