Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030601Ab0B0Q7X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:59:23 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41119 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030525Ab0B0Q6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:58:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=nAbOwmScLS+vq8CYbez4zU0skLnRkWB/v0JghBX6RTWmcVn+mDA8cFK1VzZqNU4mJS
         LaTuJMTNnVG6lQ3UWHP+oM/xhEEIQLyn8fdXh2i9aWEiBRlMBhKRmwu7t1tSWQ+9U8ge
         jGDgA7WsesknLNvjyBxM6YxaZhDN29k6WzTCk=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Gleb Natapov <gleb@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH 62/66] arch/x86/kvm/kvm_timer.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:43 +0100
Message-Id: <1267289508-31031-63-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kvm/kvm_timer.h:13: ERROR: code indent should use tabs where possible

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/x86/kvm/kvm_timer.h |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/kvm_timer.h b/arch/x86/kvm/kvm_timer.h
index 55c7524..64bc6ea 100644
--- a/arch/x86/kvm/kvm_timer.h
+++ b/arch/x86/kvm/kvm_timer.h
@@ -10,9 +10,7 @@ struct kvm_timer {
 };
 
 struct kvm_timer_ops {
-        bool (*is_periodic)(struct kvm_timer *);
+	bool (*is_periodic)(struct kvm_timer *);
 };
 
-
 enum hrtimer_restart kvm_timer_fn(struct hrtimer *data);
-
-- 
1.7.0.90.g251a4

