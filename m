Return-Path: <linux-kernel-owner+w=401wt.eu-S1758284AbYEOW5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284AbYEOW5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 18:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754525AbYEOW5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 18:57:23 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:22707 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbYEOW5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 18:57:22 -0400
Message-Id: <20080515220726.029505668@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Thu, 15 May 2008 16:07:26 -0600
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
Cc: Takashi Iwai <tiwai@suse.de>
Subject: [patch 0/4] PNP: convert resource table to dynamic list, v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series replaces the fixed-size pnp_resource_table with a
linked list of resources.

This iteration fixes a null pointer dereference Andrew found
on a PNPBIOS machine.

Because of that problem, Andrew dropped the following patches
from the -mm tree (these were patches 6-8 of the v1 series):

  pnp-replace-pnp_resource_table-with-dynamically-allocated-resources.patch
  pnp-remove-ratelimit-on-add-resource-failures.patch
  pnp-dont-sort-by-type-in-sys-resources.patch

This posting doesn't repeat patches 1-5 from the original v1 series;
the first is already in Linus's tree, and the rest are still in -mm.

Bjorn
-- 
