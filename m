Return-Path: <linux-kernel-owner+w=401wt.eu-S1759573AbYGCMdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759573AbYGCMdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755413AbYGCMde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:33:34 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:48453 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758004AbYGCMdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:33:32 -0400
Date: Thu, 3 Jul 2008 17:59:43 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       apw@shadowen.org
Subject: [BUILD-FAILURE] 2.6.26-rc8-mm1 - x86 - __ptep_modify_prot_start() missing
Message-ID: <20080703122943.GB6451@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20080703020236.adaa51fa.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080703020236.adaa51fa.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

2.6.26-rc8-mm1 kernel build fails on the x86

  CC      arch/x86/kernel/paravirt.o
arch/x86/kernel/paravirt.c:383: error: ‘__ptep_modify_prot_start’ undeclared here (not in a function)
make[1]: *** [arch/x86/kernel/paravirt.o] Error 1
make: *** [arch/x86/kernel] Error 2

linux-next patches has the changes to the adds the function
__ptep_modify_prot_start as inline, the patch s390-build-fixes.patch
is coverting it into macro. Reverting the s390-build-fixes.patch
fixes the build failure.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
