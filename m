Return-Path: <linux-kernel-owner+w=401wt.eu-S933236AbYCEApO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236AbYCEApO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 19:45:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758100AbYCEAoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 19:44:55 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:30981 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbYCEAox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 19:44:53 -0500
Date: Tue, 4 Mar 2008 17:42:52 -0700
From: Alex Chiang <achiang@hp.com>
To: Greg KH <gregkh@suse.de>
Cc: Matthew Wilcox <matthew@wil.cx>, Gary Hade <garyhade@us.ibm.com>,
       kaneshige.kenji@jp.fujitsu.com, warthog19@eaglescrag.net,
       kristen.c.accardi@intel.com, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-acpi@vger.kernel.org
Subject: [PATCH 0/3, v8] PCI, ACPI: Physical PCI slot objects
Message-ID: <20080305004252.GJ3694@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Greg KH <gregkh@suse.de>, Matthew Wilcox <matthew@wil.cx>,
	Gary Hade <garyhade@us.ibm.com>, kaneshige.kenji@jp.fujitsu.com,
	warthog19@eaglescrag.net, kristen.c.accardi@intel.com,
	rick.jones2@hp.com, linux-kernel@vger.kernel.org,
	linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, all,

This is v8 of my "introduce pci_slot" series, to be considered for
inclusion in linux-next to get more test exposure and shake out
the bugs.

The major change in this revision is removing an earlier patch
which removed the 'path' sysfs attribute on SGI machines. After
review from Jesse Barnes and Prarit Bhargava, they kindly
informed me that 'path' is actually an SGI physical path, and not
a PCI address. My patch would have definitely broken userspace on
SGI machines, so I eliminated it, and 'path' remains on SGI boxes.

This brings the patch series down to a total of 3 patches:

	0001-Construct-one-fakephp-slot-per-pci-slot.patch
	0002-Introduce-pci_slot.patch
	0003-ACPI-PCI-slot-detection-driver.patch

Thanks for all the code reviews from various people.

I'm now just looking for some people to beat on this code and let
me know where I screwed up. :)

Thanks.

/ac

