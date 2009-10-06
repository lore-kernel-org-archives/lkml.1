Return-Path: <linux-kernel-owner+w=401wt.eu-S1757118AbZJFLje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118AbZJFLje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 07:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757060AbZJFLjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 07:39:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbZJFLjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 07:39:33 -0400
Message-Id: <200910061138.n96BcqkJ004709@int-mx03.intmail.prod.int.phx2.redhat.com>
Date: Tue, 6 Oct 2009 07:38:51 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf counters: Make ABI definitions available to userspace
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf counters: Make ABI definitions available to userspace

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>

--- linux-2.6.32.noarch.orig/include/linux/Kbuild
+++ linux-2.6.32.noarch/include/linux/Kbuild
@@ -126,6 +126,7 @@ header-y += nfs_mount.h
 header-y += nl80211.h
 header-y += param.h
 header-y += pci_regs.h
+header-y += perf_event.h
 header-y += pfkeyv2.h
 header-y += pg.h
 header-y += phantom.h
