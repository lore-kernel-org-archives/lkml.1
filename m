Return-Path: <linux-kernel-owner+w=401wt.eu-S1761902AbXH0TmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761902AbXH0TmQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 15:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758239AbXH0TmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 15:42:07 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:54473 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757635AbXH0TmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 15:42:06 -0400
From: Anthony Liguori <aliguori@us.ibm.com>
To: kvm-devel@lists.sourceforge.net
Cc: Anthony Liguori <aliguori@us.ibm.com>, Avi Kivity <avi@qumranet.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] KVM paravirtualization framework (v2)
Date: Mon, 27 Aug 2007 14:42:00 -0500
Message-Id: <1188243723984-git-send-email-aliguori@us.ibm.com>
X-Mailer: git-send-email 1.5.2.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset refactors KVM's paravirtualization support to better support
guest SMP and cross platform migration.  It also introduces a bare-bones KVM
paravirt_ops implementation.

I've tested this on VT and it works nicely.  I'm having trouble getting a
bzImage to boot on SVM so I haven't been able to test on SVM yet.

I've incorporated all of the feedback into this series from posting the
last series.
