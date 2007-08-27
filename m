Return-Path: <linux-kernel-owner+w=401wt.eu-S1751690AbXH0VN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbXH0VN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbXH0VNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:13:45 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1128 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbXH0VNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:13:45 -0400
Message-Id: <20070827205750.514001000@tuxland.pl>
User-Agent: quilt/0.45-1
Date: Mon, 27 Aug 2007 22:57:50 +0200
From: m.kozlowski@tuxland.pl
To: airlied@linux.ie, akpm@linux-foundation.org
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 00/23] drm: introduce drm_zalloc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	As there are many places in drm code where drm_alloc + memset is used
this patch series introduces drm_zalloc and also makes use of drm_calloc where
needed. Most of these patches save some bytes so the benefit is a few kB saved
(gcc 4.1.2) with patch applied. Also some small (style, etc.) things are fixed.
This patch series does the conversion drm tree-wide. All patches were compile
tested.

Patches are against 2.6.23-rc3-mm1. Please review and apply.

Regards,

	Mariusz

