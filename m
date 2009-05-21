Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbZEUUcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbZEUUcs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 16:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755264AbZEUUci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 16:32:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50777 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703AbZEUUch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 16:32:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [2.6.30] e1000e: pci_enable_pcie_error_reporting failed 0xfffffffb
Date: Thu, 21 May 2009 22:32:23 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
       e1000-devel@lists.sourceforge.net, linux-pm@lists.linux-foundation.org,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <200905141312.35945.elendil@planet.nl> <200905212200.14375.elendil@planet.nl>
In-Reply-To: <200905212200.14375.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905212232.24232.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 May 2009, Frans Pop wrote:
> On Thursday 14 May 2009, Frans Pop wrote:
> > With 2.6.30-rc[45] I'm always seeing this error while resuming from STR
> > on my HP 2510p notebook:
> >
> >   e1000e 0000:00:19.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
> > ! e1000e 0000:00:19.0: pci_enable_pcie_error_reporting failed 0xfffffffb
> >   e1000e 0000:00:19.0: setting latency timer to 64 
> >   e1000e 0000:00:19.0: wake-up capability disabled by ACPI
> >   e1000e 0000:00:19.0: PME# disabled
> >   e1000e 0000:00:19.0: wake-up capability disabled by ACPI
> >   e1000e 0000:00:19.0: PME# disabled
> >   e1000e 0000:00:19.0: irq 26 for MSI/MSI-X
> >
> > The error only shows up during resume, not during normal boot.
> >
> > With 2.6.29 the error is not present. Is this something that should be
> > looked into? Networking still comes up normally.
> 
> I'm still seeing this with 2.6.30-rc6. Should I just ignore it or is it an
> indication of a problem/regression?

Sorry for the lack of response.

I'm not sure if this is a symptom of a regression.  It looks like the driver
has become more verbose.

Thanks,
Rafael
