Return-Path: <linux-kernel-owner+w=401wt.eu-S1763236AbZJOWu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763236AbZJOWu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 18:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763203AbZJOWu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 18:50:28 -0400
Received: from relay2.sgi.com ([192.48.179.30]:45024 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761028AbZJOWu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 18:50:28 -0400
From: Robin Holt <holt@sgi.com>
Message-Id: <20091015223959.783988000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 15 Oct 2009 17:39:59 -0500
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@sgi.com>, Cliff Whickman <cpw@sgi.com>
Subject: [patch 0/2] x86, UV: fixups for configurations with a large number of nodes.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We need the __uv_hub_info structure to contain the correct values for
n_val, gpa_mask, and lowmem_remap_*.  The first patch in the series
accomplishes this.   Could this be included in the stable tree as well.
Without this patch, booting a large configuration hits a problem where
the upper bits of the gnode affect the pnode and the bau will not operate.

The second patch cleans up the broadcast assist unit code a small bit.

Thanks,
Robin Holt
