Return-Path: <linux-kernel-owner+w=401wt.eu-S1757431AbZDNS1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431AbZDNS1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756433AbZDNS1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:27:30 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:38134 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210AbZDNS12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:27:28 -0400
Subject: [BUILD FAILURE 01/04] Next April 14 : x86 randconfig
	[kernel/module.c]
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: Ingo Molnar <mingo@elte.hu>, Richard Henderson <rth@twiddle.net>,
       Rusty Russell <rusty@rustcorp.com.au>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next <linux-next@vger.kernel.org>,
       sachinp <sachinp@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=utf-8
Organization: IBM
Date: Tue, 14 Apr 2009 23:57:07 +0530
Message-Id: <1239733627.5344.69.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Observed the following build error:
---
kernel/module.c: In function ‘sys_init_module’:
kernel/module.c:2398: error: ‘modules_disabled’ undeclared (first use in
this function)
kernel/module.c:2398: error: (Each undeclared identifier is reported
only once
kernel/module.c:2398: error: for each function it appears in.)
make[1]: *** [kernel/module.o] Error 1
make: *** [kernel] Error 2
---

Occurs also on x86_64 and PPC64. Fix is available:
http://patchwork.kernel.org/patch/16535/,

Probably till to make into this tree.

Regards--
Subrata


