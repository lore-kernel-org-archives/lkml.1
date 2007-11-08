Return-Path: <linux-kernel-owner+w=401wt.eu-S1760127AbXKHCqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127AbXKHCqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 21:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751107AbXKHCqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 21:46:39 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:56658 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbXKHCqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 21:46:38 -0500
From: Anthony Liguori <aliguori@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Anthony Liguori <aliguori@us.ibm.com>,
       Rusty Russell <rusty@rusycorp.com.au>, virtualization@lists.osdl.org,
       kvm-devel@lists.sourceforge.net
Subject: [PATCH 0/3] virtio PCI driver
Date: Wed,  7 Nov 2007 20:46:29 -0600
Message-Id: <11944899922822-git-send-email-aliguori@us.ibm.com>
X-Mailer: git-send-email 1.5.2.5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series implements a PCI driver for virtio.  This allows virtio
devices (like block and network) to be used in QEMU/KVM.  I'll post a very
early KVM userspace backend in kvm-devel for those that are interested.

This series depends on the two virtio fixes I've posted and Rusty's config_ops
refactoring.  I've tested with these patches on Rusty's experimental virtio
tree.
