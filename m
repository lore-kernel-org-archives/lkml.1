Return-Path: <linux-kernel-owner+w=401wt.eu-S933686AbYCFRuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933686AbYCFRuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 12:50:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755438AbYCFRuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 12:50:07 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:42815 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758962AbYCFRuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 12:50:05 -0500
Date: Thu, 6 Mar 2008 09:49:53 -0800
From: Gary Hade <garyhade@us.ibm.com>
To: Alex Chiang <achiang@hp.com>
Cc: Greg KH <gregkh@suse.de>, Matthew Wilcox <matthew@wil.cx>,
       Gary Hade <garyhade@us.ibm.com>, kaneshige.kenji@jp.fujitsu.com,
       warthog19@eaglescrag.net, kristen.c.accardi@intel.com,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org,
       lcm@us.ibm.com
Subject: Re: [PATCH 0/3, v8] PCI, ACPI: Physical PCI slot objects
Message-ID: <20080306174952.GC6041@us.ibm.com>
References: <20080305004252.GJ3694@ldl.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080305004252.GJ3694@ldl.fc.hp.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2008 at 05:42:52PM -0700, Alex Chiang wrote:
> Hi Greg, all,
> 
> This is v8 of my "introduce pci_slot" series, to be considered for
> inclusion in linux-next to get more test exposure and shake out
> the bugs.
> 
> The major change in this revision is removing an earlier patch
> which removed the 'path' sysfs attribute on SGI machines. After
> review from Jesse Barnes and Prarit Bhargava, they kindly
> informed me that 'path' is actually an SGI physical path, and not
> a PCI address. My patch would have definitely broken userspace on
> SGI machines, so I eliminated it, and 'path' remains on SGI boxes.
> 
> This brings the patch series down to a total of 3 patches:
> 
> 	0001-Construct-one-fakephp-slot-per-pci-slot.patch
> 	0002-Introduce-pci_slot.patch
> 	0003-ACPI-PCI-slot-detection-driver.patch
> 
> Thanks for all the code reviews from various people.
> 
> I'm now just looking for some people to beat on this code and let
> me know where I screwed up. :)

Hi Alex,
The x3950 M2 on which the earlier reported Oops (invalid opcode
while in acpi_ev_notify_dispatch) reproduced is unfortunately still
tied up because of a customer critical project.

I have been able to try these new patches on a single node
x3850 [2 hotpluggable PCI-X slots, 4 hotpluggable PCIe slots]
and a 2 node x3950 [12 total (6/node) hotpluggable PCI-X slots]
and found no problems.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

