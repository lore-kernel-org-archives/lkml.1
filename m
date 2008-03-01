Return-Path: <linux-kernel-owner+w=401wt.eu-S1758020AbYCAFVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020AbYCAFVx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 00:21:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754585AbYCAFVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 00:21:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48691 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731AbYCAFVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 00:21:19 -0500
Date: Fri, 29 Feb 2008 21:25:42 -0800
From: Greg KH <gregkh@suse.de>
To: Alex Chiang <achiang@hp.com>, Gary Hade <garyhade@us.ibm.com>,
       kaneshige.kenji@jp.fujitsu.com, warthog19@eaglescrag.net,
       Matthew Wilcox <matthew@wil.cx>, kristen.c.accardi@intel.com,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 4/4] ACPI PCI slot detection driver
Message-ID: <20080301052542.GD19353@suse.de>
References: <20080229002341.GA21420@ldl.fc.hp.com> <20080229002938.GE21420@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080229002938.GE21420@ldl.fc.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 05:29:38PM -0700, Alex Chiang wrote:
> Detect all physical PCI slots as described by ACPI, and create
> entries in /sys/bus/pci/slots/.
> 
> Not all physical slots are hotpluggable, and the acpiphp module
> does not detect them. Now we know the physical PCI geography of
> our system, without caring about hotplug.

What is the guarantee that the names of these slots are correct and do
not happen to be the same as the hotpluggable ones?

Why show this information on machines that can not do anything with
these slots at all?  Will that not just confuse people?

thanks,

greg k-h
