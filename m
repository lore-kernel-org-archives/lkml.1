Return-Path: <linux-kernel-owner+w=401wt.eu-S1754911AbYENUou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbYENUou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 16:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751071AbYENUom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 16:44:42 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:41513 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbYENUom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 16:44:42 -0400
Date: Wed, 14 May 2008 13:43:18 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, davidel@xmailserver.org, drepper@redhat.com
Subject: Re: 2.6.26-rc2-mm1 (CONFIG_*FD build errors)
Message-Id: <20080514134318.d888457f.randy.dunlap@oracle.com>
In-Reply-To: <20080514010129.4f672378.akpm@linux-foundation.org>
References: <20080514010129.4f672378.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008 01:01:29 -0700 Andrew Morton wrote:

> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc2/2.6.26-rc2-mm1/

With CONFIG_*FD=n:
# CONFIG_SIGNALFD is not set
# CONFIG_TIMERFD is not set
# CONFIG_EVENTFD is not set

the build fails with:

arch/x86/kernel/built-in.o: In function `sys_call_table':
(.rodata+0x89c): undefined reference to `sys_signalfd4'
arch/x86/kernel/built-in.o: In function `sys_call_table':
(.rodata+0x8a0): undefined reference to `sys_eventfd2'
make[1]: *** [.tmp_vmlinux1] Error 1

---
~Randy
