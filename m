Return-Path: <linux-kernel-owner+w=401wt.eu-S1760836AbXKHKgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760836AbXKHKgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 05:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759511AbXKHKfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 05:35:08 -0500
Received: from il.qumranet.com ([82.166.9.18]:52462 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757627AbXKHKfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 05:35:01 -0500
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] KVM fixes for 2.6.24-rc2
Date: Thu,  8 Nov 2007 12:35:25 +0200
Message-Id: <11945181301744-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I intend to submit the following patchset shortly for mainline.  All fixes are
for fairly serious issues, including host crashes.  Several will go into
-stable as well.

Please review.

 drivers/kvm/svm.c         |   18 ++++++++++++++----
 drivers/kvm/x86_emulate.c |   26 ++++++++++++++------------
 2 files changed, 28 insertions(+), 16 deletions(-)
