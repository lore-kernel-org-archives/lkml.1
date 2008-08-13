Return-Path: <linux-kernel-owner+w=401wt.eu-S1754741AbYHMBdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbYHMBdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 21:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbYHMBdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 21:33:07 -0400
Received: from bee.hiwaay.net ([216.180.54.11]:13389 "EHLO bee.hiwaay.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252AbYHMBdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 21:33:06 -0400
Date: Tue, 12 Aug 2008 20:32:55 -0500
From: Chris Adams <cmadams@hiwaay.net>
To: linux-kernel@vger.kernel.org
Subject: AGP aperture beyond 4GB not valid?
Message-ID: <20080813013255.GD633804@hiwaay.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have an MSI K9A Platinum motherboard (AMD CrossFire 580X and SB600
chipset) with 4G RAM, and I'm running Fedora 9 (x86_64) with kernel
2.6.25.11-97.fc9.x86_64.  When I boot, I see the following go by:

Checking aperture...
Node 0: aperture @ 1006000000 size 32 MB
Aperture beyond 4GB. Ignoring.
No AGP bridge found
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ c000000
PM: Registered nosave memory: 000000000c000000 - 0000000010000000


My BIOS doesn't have an IOMMU option (latest BIOS available for the
mboard).  However, it appears that an aperture is allocated but the
kernel then ignores it due to where it is placed.  Why?

Is there anything I can or should do about this (what impact does this
really have)?

-- 
Chris Adams <cmadams@hiwaay.net>
Systems and Network Administrator - HiWAAY Internet Services
I don't speak for anybody but myself - that's enough trouble.
