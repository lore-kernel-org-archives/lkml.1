Return-Path: <linux-kernel-owner+w=401wt.eu-S1753347AbZKPMUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbZKPMUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:20:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbZKPMUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:20:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958AbZKPMTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:19:42 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 24/42] KVM: remove duplicated #include
Date: Mon, 16 Nov 2009 14:19:25 +0200
Message-Id: <1258373983-8693-25-git-send-email-avi@redhat.com>
In-Reply-To: <1258373983-8693-1-git-send-email-avi@redhat.com>
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Weiyi <weiyi.huang@gmail.com>

Remove duplicated #include('s) in
  arch/x86/kvm/lapic.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/lapic.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 8787637..cd60c0b 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -32,7 +32,6 @@
 #include <asm/current.h>
 #include <asm/apicdef.h>
 #include <asm/atomic.h>
-#include <asm/apicdef.h>
 #include "kvm_cache_regs.h"
 #include "irq.h"
 #include "trace.h"
-- 
1.6.5.2

