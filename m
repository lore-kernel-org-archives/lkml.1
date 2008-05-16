Return-Path: <linux-kernel-owner+w=401wt.eu-S1758476AbYEPUIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758476AbYEPUIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 16:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbYEPUIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 16:08:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40891
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752989AbYEPUID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 16:08:03 -0400
Date: Fri, 16 May 2008 13:07:58 -0700 (PDT)
Message-Id: <20080516.130758.138657725.davem@davemloft.net>
To: mingo@elte.hu
CC: linux-kernel@vger.kernel.org
Subject: tip build broken on sparc64...
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's this pteval_t stuff, probably breaks just about every
other platforms as well.

Please fix this, because I'd like to work on some ftrace
optimizations on sparc64, and do some testing of ftrace
in general.

mm/mmap.c: In function 'vm_get_page_prot_preserve':
mm/mmap.c:86: error: 'pteval_t' undeclared (first use in this function)
mm/mmap.c:86: error: (Each undeclared identifier is reported only once
mm/mmap.c:86: error: for each function it appears in.)
mm/mmap.c:86: error: expected ';' before 'newprotval'
mm/mmap.c:88: error: 'newprotval' undeclared (first use in this function)
