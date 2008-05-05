Return-Path: <linux-kernel-owner+w=401wt.eu-S1763498AbYEEWlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763498AbYEEWlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 18:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760916AbYEEWkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 18:40:03 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:45600 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760664AbYEEWj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 18:39:58 -0400
Message-Id: <20080505223630.682082986@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Mon, 05 May 2008 16:36:30 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 0/8] PNP: convert resource table to dynamic list, v1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series replaces the fixed-size pnp_resource_table with a
linked list of resources.

The first patch is in -mm already and should appear in Linus'
tree soon, so just skip that patch if necessary.

As a reminder, if anybody tests this and sees problems, the
dmesg log with CONFIG_PNP_DEBUG enabled would be a great help
to me.

Bjorn

-- 
