Return-Path: <linux-kernel-owner+w=401wt.eu-S1757839AbXK3WRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839AbXK3WRe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 17:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbXK3WR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 17:17:26 -0500
Received: from gate.crashing.org ([63.228.1.57]:46144 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768AbXK3WR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 17:17:26 -0500
Message-Id: <D16EA8BE-3C87-4345-8832-AB6112EE0FEA@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: davem@davemloft.net, wli@holomorphy.com, mingo@redhat.com,
       ralf@linux-mips.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: use of fixmap on non-x86/sh?
Date: Fri, 30 Nov 2007 16:14:55 -0600
Cc: linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ben and I are talking about using fixmap on ppc for similar  
applications to it use on x86.  However in poking around other arch's  
(sparc, mips) they appear to have some support but not as complete as  
x86.

For example both SPARC & MIPS reference __set_fixmap() in asm/fixmap.h  
but I can't find an implementation on either.

So I was wondering if there was some reason fixmap isn't as well  
supported or if its just used for a specific function on those SPARC,  
MIPS, etc. and they dont need as much functionality out of it as x86  
does.

- k
