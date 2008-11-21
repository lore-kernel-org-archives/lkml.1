Return-Path: <linux-kernel-owner+w=401wt.eu-S1757299AbYKUWRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299AbYKUWRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 17:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbYKUWRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 17:17:12 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:26472 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbYKUWRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 17:17:11 -0500
Message-ID: <154e089b0811211417l7c6c5cf8j7e248399fa7ebd20@mail.gmail.com>
Date: Fri, 21 Nov 2008 23:17:09 +0100
From: "Hannes Eder" <hannes@hanneseder.net>
To: "Alok N Kataria" <akataria@vmware.com>, "Dan Hecht" <dhecht@vmware.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] x86: vmware - fix sparse warnings
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following sparse warnings:

arch/x86/kernel/cpu/vmware.c:69:5: warning: symbol 'vmware_platform'
was not declared. Should it be static?
arch/x86/kernel/cpu/vmware.c:89:15: warning: symbol
'vmware_get_tsc_khz' was not declared. Should it be static?
arch/x86/kernel/cpu/vmware.c:107:16: warning: symbol
'vmware_set_feature_bits' was not declared. Should it be static?

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 arch/x86/kernel/cpu/vmware.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index c034bda..284c399 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -23,6 +23,7 @@

 #include <linux/dmi.h>
 #include <asm/div64.h>
+#include <asm/vmware.h>

 #define CPUID_VMWARE_INFO_LEAF	0x40000000
 #define VMWARE_HYPERVISOR_MAGIC	0x564D5868
-- 
1.5.6.3
