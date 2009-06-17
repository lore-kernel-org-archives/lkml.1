Return-Path: <linux-kernel-owner+w=401wt.eu-S1754997AbZFQQCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbZFQQCQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753938AbZFQQCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:02:00 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:11315
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752256AbZFQQCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:02:00 -0400
Message-ID: <4A391373.3050301@panasas.com>
Date: Wed, 17 Jun 2009 19:01:55 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>,
       open-osd mailing-list <osd-dev@open-osd.org>
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCHSET 0/6] exofs: few patches for Linux 2.6.31
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jun 2009 16:01:58.0813 (UTC) FILETIME=[F1BB6CD0:01C9EF64]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For review the few exofs patches I would like included for current merge window
(Linux 2.6.31)

The main effort on the exofs front was to make it pnfs-exportable. Which for now
only lives in the pnfs tree. So there was not much left outside of that.

Also for final review is the osdblk stacking block driver which is ready
for submission but is missing a supporting user-mode tool, and some more
testing love.

The list of patches:
  [PATCH 1/6] exofs: Fix bio leak in error handling path (sync read)

	A small and rare bug fix

  [PATCH 2/6] exofs: Remove IBM copyrights

	As requested by Original author and IBM folks. The code does not belong
	to IBM. (Never was)

  [PATCH 3/6] exofs: Avoid using file_fsync()

	This one is left like this. Since other options suggested are not good
	for exofs since it does not have a block-device and any of the BH stuff.

  [PATCH 4/6] MAINTAINERS: Add osd maintained files (F:)

	Use the new MAINTAINERS F: annotation for the OSD files

  [PATCH 5/6] osdblk: a Linux block device for OSD objects
  [PATCH 6/6] osdblk: Adjust queue limits to lower device's limits

	This is the proposed osdblk driver by Jeff Garzik. It as all the Kernel
	pre-requisites, but is missing a user-mode tool and more testing. So I'm
	not sure it will make it into this Kernel. But for review.

Thanks
Boaz
