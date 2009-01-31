Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbZAaUc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbZAaUc4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 15:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbZAaUcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 15:32:48 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:22801 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbZAaUcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 15:32:47 -0500
Message-ID: <4984B55A.7060503@oracle.com>
Date: Sat, 31 Jan 2009 12:32:26 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH -mmotm/fold] UV: fix header struct usage
References: <200901310909.n0V99XIZ021497@imap1.linux-foundation.org>
In-Reply-To: <200901310909.n0V99XIZ021497@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4984B55D.011E:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix uv.h struct usage:

arch/x86/include/asm/uv/uv.h:16: warning: 'struct mm_struct' declared inside parameter list
arch/x86/include/asm/uv/uv.h:16: warning: its scope is only this definition or declaration, which is probably not what you want

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/include/asm/uv/uv.h |    3 +++
 1 file changed, 3 insertions(+)

--- mmotm-2009-0131-0108.orig/arch/x86/include/asm/uv/uv.h
+++ mmotm-2009-0131-0108/arch/x86/include/asm/uv/uv.h
@@ -3,6 +3,9 @@
 
 enum uv_system_type {UV_NONE, UV_LEGACY_APIC, UV_X2APIC, UV_NON_UNIQUE_APIC};
 
+struct cpumask;
+struct mm_struct;
+
 #ifdef CONFIG_X86_UV
 
 extern enum uv_system_type get_uv_system_type(void);
