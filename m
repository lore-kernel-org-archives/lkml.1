Return-Path: <linux-kernel-owner+w=401wt.eu-S1753652AbZKPVXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbZKPVXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 16:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbZKPVXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 16:23:15 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:56360 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbZKPVXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 16:23:13 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 1/10] PM: Add flag for devices capable of generating run-time wake-up events
Date: Mon, 16 Nov 2009 22:23:15 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Shaohua Li <shaohua.li@intel.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
References: <Pine.LNX.4.44L0.0911161557130.2971-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0911161557130.2971-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911162223.15897.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 16. November 2009 22:00:49 schrieb Alan Stern:
> > > What if the user wants to override the kernel's setting?  Should there 
> > > be a sysfs attribute controlling the flag?
> >
> > 
> > I have no plans for adding anything like that.
> 
> So if the kernel makes a mistake here, the user won't be able to 
> correct it.

If the kernel cannot tell whether a device can generate a request for
remote wakeup, how would it know the enable such requests?
Now we might come to a device that has a flatly wrong firmware,
but has that really been encountered in the wild?

	Regards
		Oliver
