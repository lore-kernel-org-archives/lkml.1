Return-Path: <linux-kernel-owner+w=401wt.eu-S1753730AbZEKQci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbZEKQci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 12:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754259AbZEKQcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 12:32:22 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:24850 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755990AbZEKQcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 12:32:20 -0400
Message-ID: <4A085326.3030707@oracle.com>
Date: Mon, 11 May 2009 09:32:38 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       avi@redhat.com, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -next] kvm: fix build error: add missing semi-colon
References: <20090511161442.3e9d9cb9.sfr@canb.auug.org.au>
In-Reply-To: <20090511161442.3e9d9cb9.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt005.oracle.com [141.146.116.14]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010201.4A0852B0.03A2:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add missing ; to fix build error:

arch/x86/kvm/x86.c:1259: error: expected',' or ';' before 'const'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/kvm/x86.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20090511.orig/arch/x86/kvm/x86.c
+++ linux-next-20090511/arch/x86/kvm/x86.c
@@ -1252,7 +1252,7 @@ static void do_cpuid_ent(struct kvm_cpui
 #ifdef CONFIG_X86_64
 	unsigned f_lm = F(LM);
 #else
-	unsigned f_lm = 0
+	unsigned f_lm = 0;
 #endif
 
 	/* cpuid 1.edx */


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
