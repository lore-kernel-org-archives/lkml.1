Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbYCTHie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbYCTHie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 03:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbYCTHiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 03:38:24 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:47512 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbYCTHiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 03:38:24 -0400
Date: Thu, 20 Mar 2008 00:37:40 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Glauber de Oliveira Costa <gcosta@redhat.com>, Andi Kleen <ak@suse.de>,
       shai@scalex86.org
Subject: [patch 0/4] x86: vSMP updates
Message-ID: <20080320073740.GA9414@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, Andrew,
Here are a few updates to the vSMP architecture bits in the x86 tree.
This is a set of 4 patches which do the following:

1. Fix is_vsmp_box() to actually detect if the system is a vSMPowered box
2. Fix build issue when CONFIG_PCI is enabled, but CONFIG_PARAVIRT is not
3. Set paravirt ops only if the platform has capability to recognize
   paravirtualized irq operations
4. Update apic_is_clustered_box() to indicate unsynched TSCs on multiboard
   vSMPowered systems

The patches have been tested against 2.6.25-rc5-mm1 on vSMPowered and non
vSMPowered x86 boxes.

Please apply

Thanks,
Kiran
