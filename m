Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbXJWRmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbXJWRmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 13:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753801AbXJWRmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 13:42:24 -0400
Received: from mail-dub.bigfish.com ([213.199.154.10]:39665 "EHLO
	mail89-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815AbXJWRmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 13:42:23 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
cc: linux-kernel@vger.kernel.org, "Andi Kleen" <ak@suse.de>
Subject: [PATCH 0/4] x86: some GART cleanups
Date: Tue, 23 Oct 2007 19:41:29 +0200
Message-ID: <11931612933917-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.2.5
X-OriginalArrivalTime: 23 Oct 2007 17:41:33.0696 (UTC)
 FILETIME=[F3F2F800:01C8159B]
MIME-Version: 1.0
X-WSS-ID: 6B00EDE00QK8100-02-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches contains cleanups for the GART IOMMU implementation in
Linux. It mostly renames symbols to make clear that they belong only to the
GART and not to the implementations for other IOMMUs. It also makes some
unnecessary exported functions static in the GART implementation.




