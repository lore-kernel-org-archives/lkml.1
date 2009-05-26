Return-Path: <linux-kernel-owner+w=401wt.eu-S1754250AbZEZIgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbZEZIgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 04:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753956AbZEZIgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 04:36:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51158 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753910AbZEZIgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 04:36:12 -0400
Date: Tue, 26 May 2009 04:35:05 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu, jdike@addtoit.com,
       Amerigo Wang <amwang@redhat.com>, rusty@rustcorp.com.au
Message-Id: <20090526083717.5050.32719.sendpatchset@localhost.localdomain>
Subject: [Patch 0/4] module: merge module_32.c and module_64.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch set aims to merge module_32.c and module_64.c into
module.c. And plus some other related fixes.

Please apply in order.

I have tested this patch set on x86_64, and uml over x86_64,
and compile tested on i386. It looks fine.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>

 arch/um/sys-i386/Makefile      |    2 
 arch/um/sys-x86_64/Makefile    |    4 
 arch/um/sys-x86_64/um_module.c |   21 ---
 arch/x86/kernel/Makefile       |    4 
 arch/x86/kernel/module.c       |  262 ++++++++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/module_32.c    |  152 -----------------------
 arch/x86/kernel/module_64.c    |  194 ------------------------------
 7 files changed, 264 insertions(+), 375 deletions(-)

