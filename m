Return-Path: <linux-kernel-owner+w=401wt.eu-S1754611AbYEJLvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbYEJLvg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 07:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbYEJLva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 07:51:30 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:43112 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365AbYEJLv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 07:51:29 -0400
Date: Sat, 10 May 2008 14:51:27 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org
Subject: ppc compile failure (__flush_icache_range etc undeclared)
Message-ID: <Pine.SOC.4.64.0805101448580.8450@math.ut.ee>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tried 2.6.26-rc1+git on ppc (arch/ppc, PReP subarch) and got this:

arch/ppc/kernel/ppc_ksyms.c: At top level:
arch/ppc/kernel/ppc_ksyms.c:152: error: '__flush_icache_range' undeclared here (not in a function)
arch/ppc/kernel/ppc_ksyms.c:152: warning: type defaults to 'int' in declaration of '__flush_icache_range'
arch/ppc/kernel/ppc_ksyms.c:153: error: 'flush_dcache_range' undeclared here (not in a function)
arch/ppc/kernel/ppc_ksyms.c:153: warning: type defaults to 'int' in declaration of 'flush_dcache_range'
arch/ppc/kernel/ppc_ksyms.c:154: error: 'flush_icache_user_range' undeclared here (not in a function)
arch/ppc/kernel/ppc_ksyms.c:154: warning: type defaults to 'int' in declaration of 'flush_icache_user_range'
arch/ppc/kernel/ppc_ksyms.c:155: error: 'flush_dcache_page' undeclared here (not in a function)
arch/ppc/kernel/ppc_ksyms.c:155: warning: type defaults to 'int' in declaration of 'flush_dcache_page'
make[1]: *** [arch/ppc/kernel/ppc_ksyms.o] Error 1


-- 
Meelis Roos (mroos@linux.ee)
