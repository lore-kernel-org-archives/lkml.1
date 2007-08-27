Return-Path: <linux-kernel-owner+w=401wt.eu-S1759108AbXH0QCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759108AbXH0QCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 12:02:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758190AbXH0P4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 11:56:37 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:33629 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757442AbXH0P4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 11:56:35 -0400
From: Anthony Liguori <aliguori@us.ibm.com>
To: kvm-devel@lists.sourceforge.net
Cc: Avi Kivity <avi@qumranet.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] KVM paravirtualization framework
Date: Mon, 27 Aug 2007 10:16:43 -0500
Message-Id: <11882278064002-git-send-email-aliguori@us.ibm.com>
X-Mailer: git-send-email 1.5.2.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset refactors KVM's paravirtualization support to better support
guest SMP and cross platform migration.  It also introduces a bare-bones KVM
paravirt_ops implementation.

I've tested this on VT and it works nicely.  I'm having trouble getting a
bzImage to boot on SVM so I haven't been able to test on SVM yet.
