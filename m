Return-Path: <linux-kernel-owner+w=401wt.eu-S1753935AbYJAHlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbYJAHlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 03:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbYJAHkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 03:40:14 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:22134 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbYJAHkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 03:40:11 -0400
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: jens.axboe@oracle.com, neilb@suse.de, agk@sourceware.org
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Block integrity patches for 2.6.28
Date: Wed,  1 Oct 2008 03:38:36 -0400
Message-Id: <1222846723-18213-1-git-send-email-martin.petersen@oracle.com>
X-Mailer: git-send-email 1.6.0.2
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch series contains block layer integrity updates for 2.6.28.

There are a few fixes to the core bits, including a switch from
block_device to gendisk in the integrity compare function.  I also had
to add a helper to access a gendisk's integrity profile.  This is used
by MD.

The DM bits have been cleaned up and a separate dm_table_set_integrity
function has been introduced.  This allows us to avoid changing
dm_table_set_restrictions() and its callers.

The MD patch now correctly handles devices that come and go (as
requested by Neil).

The patches are against for-2.6.28 and depend on

    d7533ad0e132f92e75c1b2eb7c26387b25a583c1

being reverted.

--
Martin K. Petersen      Oracle Linux Engineering


