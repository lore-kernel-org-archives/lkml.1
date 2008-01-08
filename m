Return-Path: <linux-kernel-owner+w=401wt.eu-S1755491AbYAHTcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbYAHTcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 14:32:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754822AbYAHTb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 14:31:57 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:50843 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbYAHTb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 14:31:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=sp2pxKW0w4enDXZGbkcY1vUBCPDf6x2ik9yWwJ3CjyMaK9UlmIN6x1/QtZ05B0azysuSQVCrtfZDZt/2UzL527NaX2fklfv/7SJuxzIa9c4jLD0lgeL1HxA+xFKHw1sykl8aLLINun/SjduDgfo0w8FB1R6Xq3tr66f/lw6UGEU=
Date: Tue, 8 Jan 2008 20:32:06 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, mingo@elte.hu,
       Linux Kernel <linux-kernel@vger.kernel.org>, trivial@kernel.org
Subject: [PATCH1/5] x86: coding style fixes in arch/x86/ia32/audit.c
Message-ID: <20080108203206.13cfe48c@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix one error reported by checkpatch,
it now reports:

total: 0 errors, 0 warnings, 42 lines checked

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/ia32/audit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/ia32/audit.c b/arch/x86/ia32/audit.c
index 91b7b59..5d7b381 100644
--- a/arch/x86/ia32/audit.c
+++ b/arch/x86/ia32/audit.c
@@ -27,7 +27,7 @@ unsigned ia32_signal_class[] = {
 
 int ia32_classify_syscall(unsigned syscall)
 {
-	switch(syscall) {
+	switch (syscall) {
 	case __NR_open:
 		return 2;
 	case __NR_openat:
-- 
1.5.4.rc2.17.g257f

