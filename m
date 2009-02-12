Return-Path: <linux-kernel-owner+w=401wt.eu-S1758256AbZBLKPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256AbZBLKPh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 05:15:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756743AbZBLKP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 05:15:29 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41520
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756678AbZBLKP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 05:15:28 -0500
Date: Thu, 12 Feb 2009 02:15:22 -0800 (PST)
Message-Id: <20090212.021522.217840575.davem@davemloft.net>
To: airlied@linux.ie
CC: benh@kernel.crashing.org, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/5]: ATI/RADEON DRM bug fixes...
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


David, this work is against your drm-next branch.

Here are a collection of bug fixes for the Radeon DRM support.  Most
of them have to do with trying to access kernel virtual addresses
using DRM_READ32() and DRM_WRITE32().

With these patches at least the writeback test works on sparc64 and
the CP is able to process commands in the ring.  I'm now diagnosing
some further problem that's preventing Xorg from functioning fully but
I should be able to diagnose that soon.

You'll probably love patch #4 in this series, and it probably explains
all kinds of weird problems people run into with DRM on radeon cards.

Please apply, thanks.
