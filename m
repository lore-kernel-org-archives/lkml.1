Return-Path: <linux-kernel-owner+w=401wt.eu-S932851AbYCGVGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932851AbYCGVGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 16:06:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932804AbYCGVFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 16:05:43 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:16756 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932789AbYCGVFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 16:05:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=uBOd2JkCbtrLRYSUbx5ghtqd9ww9DjTJOOfFTdfke7biPxuhyWFSQOt6kbCsJy17YODu1cCqUKmBZzkGdtKISJiVYy/+oIgjOUq0KQ2fooL29xurE7+WjiGabhuPHDh1CBYnIWh98D9uras7YsCuxuc2yKzTiSuZG6AA7GtM/A8=
Message-ID: <7c86c4470803071305p3b645c53lefde1b4963edfc61@mail.gmail.com>
Date: Fri, 7 Mar 2008 13:05:39 -0800
From: "stephane eranian" <eranian@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] perfmon x86 infra(take 2): add AMD Northbridge MSR definition
Cc: "Andrew Morton" <akpm@linux-foundation.org>, ak@suse.de,
       "Ingo Molnar" <mingo@elte.hu>, tglx@linutronix.de,
       "Robert Richter" <robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

adds AMD Northbridge config MSR definition

Signed-off-by: Stephane Eranian <eranian@gmail.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>

--- a/include/asm-x86/msr-index.h
+++ b/include/asm-x86/msr-index.h
@@ -83,6 +83,7 @@
 /* AMD64 MSRs. Not complete. See the architecture manual for a more
    complete list. */

+#define MSR_AMD64_NB_CFG               0xc001001f
 #define MSR_AMD64_IBSFETCHCTL          0xc0011030
 #define MSR_AMD64_IBSFETCHLINAD                0xc0011031
 #define MSR_AMD64_IBSFETCHPHYSAD       0xc0011032
