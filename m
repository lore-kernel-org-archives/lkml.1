Return-Path: <linux-kernel-owner+w=401wt.eu-S932859AbYBNXkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932859AbYBNXkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 18:40:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759472AbYBNXkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 18:40:04 -0500
Received: from havoc.gtf.org ([69.61.125.42]:35831 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759390AbYBNXkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 18:40:03 -0500
Message-Id: <74fc75b3eadfa82aee70b855e9944b5439a259d5.1203031878.git.jeff@garzik.org>
From: Jeff Garzik <jeff@garzik.org>
To: linux-kernel@vger.kernel.org, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de
CC: Greg KH <greg@kroah.com>
Date: Tue, 17 Jul 2007 23:04:04 -0400
Subject: [PATCH 00/14] [ISDN] HiSax hotplug conversion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a refresh of an on-going work-in-progress:  convert the last
remaining users of pci_find_device() to the ISA/PCI/etc.  hotplug APIs
now in standard use.  After SCSI's gdth, ISDN's HiSax suite of drivers
are just about the last place using the older API.

A few rough edges remain, and I'm not sure how much of ISDN userland
will explode (I have no ISDN hardware, nor much want any:)), but this
should get us almost all the way there.

The patches are diff'd against 2.6.25-rc1.

Comments/review/testing welcome.  Especially "it works" or "its dead"
testing.

