Return-Path: <linux-kernel-owner+w=401wt.eu-S1756116AbYLIU0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbYLIU0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:26:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755280AbYLIUXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:23:25 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34854 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754733AbYLIUXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:09 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 16/44] Merge branch 'x86/crashdump' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
Date: Tue,  9 Dec 2008 22:22:31 +0200
Message-Id: <1228854179-23002-17-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 arch/x86/include/asm/kexec.h         |   31 +++++-----
 arch/x86/include/asm/reboot.h        |    5 ++
 arch/x86/kernel/crash.c              |   70 +++------------------
 arch/x86/kernel/machine_kexec_32.c   |  104 ++++++++++++++++++++++++-------
 arch/x86/kernel/reboot.c             |   95 ++++++++++++++++++++++++++++
 arch/x86/kernel/relocate_kernel_32.S |  115 ----------------------------------
 include/linux/kexec.h                |    4 +
 7 files changed, 210 insertions(+), 214 deletions(-)

[This is a merge from the x86 forest]
