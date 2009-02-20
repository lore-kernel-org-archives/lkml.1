Return-Path: <linux-kernel-owner+w=401wt.eu-S1756328AbZBTILP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbZBTILP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 03:11:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbZBTIK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 03:10:59 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:55950 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbZBTIK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 03:10:58 -0500
Message-Id: <200902200810.n1K8AtRj063682@www262.sakura.ne.jp>
Subject: [linux-next-20090219] \"struct pgprot\" incomplete type warning.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 20 Feb 2009 17:10:53 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 20022009 #1641522, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When compiling on Sarge (gcc (GCC) 3.3.5), below warning appears on every file.
Though it is harmless, is it possible to make compiler silent?
-----
In file included from /usr/src/linux/kernel/git/sfr/linux-next.git/arch/x86/include/asm/page.h:8,
                 from /usr/src/linux/kernel/git/sfr/linux-next.git/arch/x86/include/asm/thread_info.h:11,
                 from include/linux/thread_info.h:55,
                 from include/linux/preempt.h:9,
                 from ......:..,
                 from ......:..,
/usr/src/linux/kernel/git/sfr/linux-next.git/arch/x86/include/asm/page_types.h:54: warning: parameter has incomplete type
/usr/src/linux/kernel/git/sfr/linux-next.git/arch/x86/include/asm/page_types.h:56: warning: parameter has incomplete type
-----
Regards.
