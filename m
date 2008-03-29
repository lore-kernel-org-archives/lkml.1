Return-Path: <linux-kernel-owner+w=401wt.eu-S1754594AbYC2KdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbYC2KdJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 06:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbYC2Kc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 06:32:58 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:48899 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbYC2Kc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 06:32:57 -0400
Date: Sat, 29 Mar 2008 12:32:56 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: PPC: 'xchg_u32' is static but used in inline function 'xchg_ptr'
 which is not static
Message-ID: <Pine.SOC.4.64.0803291231160.5386@math.ut.ee>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While compiling yesterdays 2.6.25-rc7+git on ppc (ppc subarch, not 
powerpc), most files give this warning:

In file included from include/linux/list.h:9,
                 from include/linux/module.h:9,
                 from init/version.c:10:
include/asm/system.h: In function 'xchg_ptr':
include/asm/system.h:183: warning: 'xchg_u32' is static but used in inline function 'xchg_ptr' which is not static

-- 
Meelis Roos (mroos@linux.ee)
