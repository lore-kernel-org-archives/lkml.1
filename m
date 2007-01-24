Return-Path: <linux-kernel-owner+w=401wt.eu-S1751229AbXAXLZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751229AbXAXLZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 06:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbXAXLZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 06:25:38 -0500
Received: from ipmail03.adl2.internode.on.net ([203.16.214.135]:53752 "EHLO
	ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751229AbXAXLZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 06:25:37 -0500
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Jan 2007 06:25:36 EST
X-IronPort-AV: i="4.13,231,1167571800"; 
   d="scan'208"; a="39454194:sNHT17432184"
From: airlied@linux.ie
To: linux-kernel@vger.kernel.org
Subject: gpu sharing layer for kernel
Date: Wed, 24 Jan 2007 22:20:18 +1100
Message-Id: <1169637623985-git-send-email-airlied@linux.ie>
X-Mailer: git-send-email 1.4.1.ga3e6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series contains the gpu sharing layer for kernel that I've mentioned before. It should apply against Linus's git tree.

Why do we want this?

Currently the kernel cannot provide both the fb and drm drivers with access to the device model and this means the drm cannot get any suspend/resume callbacks. 
This layer attempts to fix this problem by adding a bus for the gpu drivers
to attach to. Currently a lowlevel binding driver is needed along with optional
fb and drm components.

This patch series only covers the generic code and radeon initially, I'll
probably target intel next.

All the patches are available at:
http://www.skynet.ie/~airlied/patches/gpu

I think maybe the radeonfb patch may not make it pass the list filter..

Dave.

