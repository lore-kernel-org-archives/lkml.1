Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614AbZLAWtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbZLAWtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 17:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbZLAWtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 17:49:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46877 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbZLAWti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 17:49:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFC][PATCH 11/12] PCI PM: Run-time callbacks for PCI bus type (rev. 2)
Date: Tue, 1 Dec 2009 23:50:13 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc8-rjw; KDE/4.3.3; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Oliver Neukum <oliver@neukum.org>, Shaohua Li <shaohua.li@intel.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Francois Romieu <romieu@fr.zoreil.com>, Len Brown <lenb@kernel.org>
References: <200911160047.46299.rjw@sisk.pl> <200911291643.15603.rjw@sisk.pl> <20091201220043.GA17093@srcf.ucam.org>
In-Reply-To: <20091201220043.GA17093@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912012350.13384.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 December 2009, Matthew Garrett wrote:
> On Sun, Nov 29, 2009 at 04:43:15PM +0100, Rafael J. Wysocki wrote:
> 
> > -	if (enable && !device_may_wakeup(&dev->dev))
> > +	if (enable && runtime && !device_may_wakeup(&dev->dev))
> 
> Should this be !runtime? We only care about device_may_wakeup() in the 
> system suspend case.

Yes, it should, thanks!
