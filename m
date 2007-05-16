Return-Path: <linux-kernel-owner+w=401wt.eu-S1762271AbXEPDNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762271AbXEPDNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 23:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755150AbXEPDNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 23:13:17 -0400
Received: from gherkin.frus.com ([192.158.254.49]:49519 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754576AbXEPDNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 23:13:16 -0400
Subject: [BUG] (regression) AMD k6-III/450 won't boot w/2.6.22-rc1
To: linux-kernel@vger.kernel.org
Date: Tue, 15 May 2007 22:13:14 -0500 (CDT)
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20070516031315.132DFDBA1@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The 2.6.22-rc1 boot panics early in amd_mcheck_init() with my k6-III/450.
It panics early enough that some of what I'm sure would be useful has
already scrolled off the screen, and there's no scrollback buffer at
that point.  If more detail is needed, I'll have to transcribe what I
*can* see by hand.

Here's /proc/cpuinfo on the chance it will help someone track this down:

processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 5
model		: 9
model name	: AMD-K6(tm) 3D+ Processor
stepping	: 1
cpu MHz		: 451.032
cache size	: 256 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr mce cx8 pge mmx syscall 3dnow k6_mtrr
bogomips	: 902.76
clflush size	: 32

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------
