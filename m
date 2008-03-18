Return-Path: <linux-kernel-owner+w=401wt.eu-S937088AbYCSVZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937088AbYCSVZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757363AbYCSUAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:00:54 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:45046 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762115AbYCSUAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:00:48 -0400
Date: Tue, 18 Mar 2008 15:05:39 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>, Greg KH <gregkh@suse.de>
Cc: Gary Hade <garyhade@us.ibm.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: [PATCH 0/3, v10] PCI, ACPI: Physical PCI slot objects
Message-ID: <20080318210539.GA30421@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	Greg KH <gregkh@suse.de>, Gary Hade <garyhade@us.ibm.com>,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
	Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
	rick.jones2@hp.com, linux-kernel@vger.kernel.org,
	linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, Kenji-san,

This is v10 of my "introduce pci_slot" series, to be considered
for inclusion in linux-next to get more test exposure and shake
out the bugs.

* Greg KH <gregkh@suse.de>:
> Can you work with Kenji to get his approval on this before I
> add this to the tree?  It sounds like there are still some
> outstanding issues getting this to work properly on his
> hardware.  It needs to work without relying on a module not
> being loaded, as the distros are never going to go for that
> kind of solution.

New in v10 is the addition of a DMI list to do the right thing on
Fujitsu hardware, and does not rely on "don't load the module" to
get the correct behavior.

Also, v10 should fix the "pci_slot module changes the sysfs name"
issue that Kenji-san was seeing.

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> Alex-san, could you send me the updated patches? I'll Ack the
> patch after adding Fujitsu firmware versions to the DMI list
> and testing it.

Thanks, I'd like to know if the naming issue is fixed for you as
well.

cheers,

/ac

