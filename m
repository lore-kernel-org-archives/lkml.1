Return-Path: <linux-kernel-owner+w=401wt.eu-S1756046AbYCYENZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbYCYENZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 00:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332AbYCYENQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 00:13:16 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:47360 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbYCYENP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 00:13:15 -0400
Date: Mon, 24 Mar 2008 22:13:14 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Greg KH <gregkh@suse.de>, Gary Hade <garyhade@us.ibm.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: [PATCH 0/4, v11] PCI, ACPI: Physical PCI slot objects
Message-ID: <20080325041314.GA29666@ldl.fc.hp.com>
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

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> I've reviewed and tested the latest version of Alex's
> "introduce pci_slot" series [and] I found some bugs and some
> codes need to be changed.

First, many thanks to Kenji-san for his code review and
subsequent patches. They really improved the code a lot!

I've merged all his changes into my series, with the thought that
it will be better to contain all the fixes in one spot for future
bisectability purposes.

I gave Kenji-san credit in the changelog, as well at the top of
drivers/acpi/pci_slot.c, but if that's not sufficient, we can
certainly add more attributions where it's appropriate. Please
let me know.

This is v11 of the physical pci_slot series. It should be *very*
close to what I'd like to see in linux-next for further testing.
I would appreciate any final code review and if it looks ok,
maybe finally get it merged upstream. ;)

Thanks to all testers, reviewers, and commenters.

/ac

