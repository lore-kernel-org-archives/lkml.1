Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbYCKVZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbYCKVZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 17:25:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbYCKVY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 17:24:56 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:17656 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbYCKVYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 17:24:55 -0400
Message-Id: <20080311212439.293001409@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Tue, 11 Mar 2008 15:24:39 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: alsa-devel@alsa-project.org
Cc: linux-acpi@vger.kernel.org
Cc: Len Brown <lenb@kernel.org>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Matthew Hall <mhall@mhcomputing.net>
Cc: Willem Riede <wriede@riede.org>
Cc: Robert Hancock <hancockr@shaw.ca>
Cc: Karl Bellve <karl.bellve@umassmed.edu>
Cc: Avuton Olrich <avuton@gmail.com>
Subject: [patch 0/2] PNP: disable PNP motherboard resources that overlap PCI BARs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following two patches fix several problems caused by BIOSes that
report PNP motherboard device resources that overlap with PCI BARs.

I think these should go in before 2.6.25 because some of these problems
showed up in 2.6.24 when we increased PNP_MAX_MEM from 4 to 12, and
there's no good way to work around them.

Bjorn
-- 
