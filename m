Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbYAVTvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbYAVTvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 14:51:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbYAVTvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 14:51:45 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:33243 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbYAVTvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 14:51:44 -0500
Date: Tue, 22 Jan 2008 20:51:43 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       tglx@linutronix.de
Subject: [PATCH] x86: constify function pointer tables
In-Reply-To: <54038cd4f87a03884e4f59f8f3697889dfb63c54.1201030614.git.jengelh@computergmbh.de>
Message-ID: <Pine.LNX.4.64.0801222051140.5722@fbirervta.pbzchgretzou.qr>
References: <54038cd4f87a03884e4f59f8f3697889dfb63c54.1201030614.git.jengelh@computergmbh.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 arch/x86/kernel/cpu/proc.c |    2 +-
 arch/x86/kernel/setup_64.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 3900e46..0282132 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -188,7 +188,7 @@ static void *c_next(struct seq_file *m, void *v, loff_t *pos)
 static void c_stop(struct seq_file *m, void *v)
 {
 }
-struct seq_operations cpuinfo_op = {
+const struct seq_operations cpuinfo_op = {
 	.start	= c_start,
 	.next	= c_next,
 	.stop	= c_stop,
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 30d94d1..52ef415 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -1184,7 +1184,7 @@ static void c_stop(struct seq_file *m, void *v)
 {
 }
 
-struct seq_operations cpuinfo_op = {
+const struct seq_operations cpuinfo_op = {
 	.start =c_start,
 	.next =	c_next,
 	.stop =	c_stop,
-- 
1.5.3.4

