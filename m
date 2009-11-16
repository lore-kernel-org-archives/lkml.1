Return-Path: <linux-kernel-owner+w=401wt.eu-S1753269AbZKPTi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbZKPTi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 14:38:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbZKPTi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 14:38:58 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:59249 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752177AbZKPTi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 14:38:58 -0500
Date: Mon, 16 Nov 2009 14:39:03 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Oliver Neukum <oliver@neukum.org>, Shaohua Li <shaohua.li@intel.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [RFC][PATCH 1/10] PM: Add flag for devices capable of generating
 run-time wake-up events
In-Reply-To: <200911160049.22717.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0911161436560.2971-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Nov 2009, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Apparently, there are devices that can wake up the system from sleep
> states and yet are incapable of generating wake-up events at run
> time.  Thus, introduce a flag indicating if given device is capable
> of generating run-time wake-up events.

This raises the question: Who is responsible for setting the new 
flag?  The code that registers the device?

What if the kernel can't tell whether or not the device can generate 
runtime wake-up events?

What if the user wants to override the kernel's setting?  Should there 
be a sysfs attribute controlling the flag?

Alan Stern

