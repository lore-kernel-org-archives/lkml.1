Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbYE3Wtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbYE3Wtm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 18:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbYE3Wt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 18:49:28 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:2394 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbYE3Wt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 18:49:27 -0400
Message-Id: <20080530224853.976744229@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 30 May 2008 16:48:53 -0600
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
Subject: [patch 00/15] PNP: convert resource options to unified dynamic list, v1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series converts the PNP resource option structures
to a unified linked list.  This preserves resource order, which
is important for some devices.  There's more detail in the
comments for the last patch.

Any comments would be welcome.

This depends on some patches that are in -mm, but not yet
upstream.  In mmotm, these would probably go after
pnp-dont-sort-by-type-in-sys-resources.patch

Bjorn
-- 
