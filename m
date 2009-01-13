Return-Path: <linux-kernel-owner+w=401wt.eu-S1756547AbZAMLqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbZAMLqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 06:46:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbZAMLqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 06:46:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49595 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109AbZAMLqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 06:46:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: Regression 2.6.28-git: suspend/resume failure. git bisected to usb suspend/resume patch
Date: Tue, 13 Jan 2009 12:45:57 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc1-rjw; KDE/4.1.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       lkml <linux-kernel@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org
References: <200901111348.46216.borntraeger@de.ibm.com> <200901121341.51674.rjw@sisk.pl> <200901130907.13820.borntraeger@de.ibm.com>
In-Reply-To: <200901130907.13820.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901131245.58112.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 January 2009, Christian Borntraeger wrote:
> Am Montag 12 Januar 2009 schrieb Rafael J. Wysocki:
> > > Please try if suspend-resume works for you if you make commit
> > > fa58d305d9925b01830e535896a7227a868a9e15
> > > (PCI PM: Add suspend counterpart of pci_reenable_device) the head of your
> > > tree ('git checkout -b test-branch 
> fa58d305d9925b01830e535896a7227a868a9e15').
> > > 
> > > If it does, please check the same for commit
> > > 571ff7584bb9e05fca0eb79752ae55a46faf3a98
> > > (PCI PM: Power-manage devices without drivers during suspend-resume).
> > 
> > Ah, please do the above with the USB commit
> > a0d4922da2e4ccb0973095d8d29f36f6b1b5f703 reverted.
> 
> Will do.
> 
> In the meantime I have bisected another problem: 
> commit 7503bfbae89eba07b46441a5d1594647f6b8ab7d
> Author: Mike Travis <travis@sgi.com>
> Date:   Sun Jan 4 05:18:09 2009 -0800
> 
>     cpumask: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write
> 
> but I just see that this is already known.
> O dear. How many patches do we know that broke S2R in this merge window? 4? 5?

We _know_ of 2.  The others were just good testing points.

Thanks,
Rafael
