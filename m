Return-Path: <linux-kernel-owner+w=401wt.eu-S1753802AbXLFMli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbXLFMli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:41:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbXLFMl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:41:29 -0500
Received: from nic2.axis.se ([193.13.178.10]:35702 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbXLFMl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:41:28 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Date: Thu, 29 Nov 2007 17:02:22 +0100
Subject: [PATCH 00/47] CRIS patches for CRISv32 EtraxFS and ARTPEC-3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset contains the differences to add support for the EtraxFS and
ARTPEC-3 CPUs, both of the CRISv32 family.  Both chips can now be compiled
with minimal configs.

To compile you'll need the Axis gcc cross port for CRISv32, it is mentioned
in http://marc.info/?l=linux-kernel&m=119337976126184&w=2 how to get this.

Still missing to allow full compile is include/linux/mtd/mtdram.h,
see http://marc.info/?l=linux-kernel&m=119373777301863&w=2

This is step two in syncing the Axis internal changes with mainline Linux,
with the final goal being getting the CRIS port to the same level as
the rest of the kernel.

I've tried to remove as much checkpatch warnings and errors as possible,
but some remain, mostly (I think you'll agree) spurious warnings,
although there's also a bunch of generated files which don't conform,
but I hope to fix this at the source later on.

I realise this is a hefty chunk of code to review, but any suggestions
on improvements are thankfully received.

The changes are also available in the export2 branch at

git://www.jni.nu/axis.git

Best regards,

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
