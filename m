Return-Path: <linux-kernel-owner+w=401wt.eu-S1758712AbYD2Khm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712AbYD2Khm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 06:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754035AbYD2Khd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 06:37:33 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:10889
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbYD2Khc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 06:37:32 -0400
From: Amit Shah <amit.shah@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: virtualization@lists.linux-foundation.org, muli@il.ibm.com,
       BENAMI@il.ibm.com, gcosta@redhat.com, chrisw@redhat.com,
       dor.laor@qumranet.com, allen.m.kay@intel.com, avi@qumranet.com,
       linux-kernel@vger.kernel.org
Subject: PV DMA for PCI passthrough devices for KVM
Date: Tue, 29 Apr 2008 13:37:28 +0300
Message-Id: <1209465451-3758-1-git-send-email-amit.shah@qumranet.com>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patchset implements PVDMA for handling DMA requests from
devices assigned to the guest from the host machine.

They're also available from

git-pull git://git.kernel.org/pub/scm/linux/kernel/git/amit/kvm.git pvdma

These patches are based on my pci-passthrough tree, which is available
from

git-pull git://git.kernel.org/pub/scm/linux/kernel/git/amit/kvm.git

and the userspace from

git-pull git://git.kernel.org/pub/scm/linux/kernel/git/amit/kvm-userspace.git

The first and the third patch in this series is needed on the guest (with some
bits from the 2nd as well). The 2nd patch is meant for the host kernel.

Amit.
