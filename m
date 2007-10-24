Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbXJXFtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbXJXFtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 01:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbXJXFtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 01:49:12 -0400
Received: from mail.progtech.ru ([62.117.85.73]:38570 "EHLO mail.progtech.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbXJXFtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 01:49:11 -0400
X-Spam-Scaned: by SPAMASSASSIN
Date: Wed, 24 Oct 2007 09:49:07 +0400
From: "Oleg A. Arkhangelsky" <sysoleg@progtech.ru>
X-Mailer: The Bat! (v2.12.00) Business
Reply-To: "Oleg A. Arkhangelsky" <sysoleg@progtech.ru>
X-Priority: 3 (Normal)
Message-ID: <1397016698.20071024094907@progtech.ru>
To: linux-kernel@vger.kernel.org
Subject: Re: Hard lockups on 2.6.22.4-SMP
In-Reply-To: <1696948867.20071023164555@progtech.ru>
References: <1696948867.20071023164555@progtech.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

      Answering to myself.

OAA> We  have  a  problem  with  spontaneous (there is no relation with CPU
OAA> load,  memory  load,  uptime)  hard  lockups  on  linux  2.6.22.4  (no
OAA> additional patches) on SMP system (Intel E7230 ICH7 Montherboard). Num
OAA> Lock  (Caps  Lock - no matter) on keyboard is not responding. There is
OAA> no  debug  on  console (no oops, no kernel panic, no NMI watchdog info
OAA> [but nmi_watchdog=1 and NMI in /proc/interrupts is OK]). All we see is
OAA> just previous console state (for example - login: prompt). We have the
OAA> same  situation  on  another PC with abosolutely the some hardware and
OAA> software  configuration.  Could  you  give  us some hints about how to
OAA> debug  this  situation?  If you need some additional information about
OAA> our  system, feel free to ask. I can post a lot of output (i.e. lspci,
OAA> dmesg, etc...) but i don't want to post any useless information.

     Yesterday we added CONFIG_DEBUG_SPINLOCK and
     CONFIG_DEBUG_SPINLOCK_SLEEP to our kernel config.

     After six hours of uptime we got the same lockup, but the kernel
     became a little verbose:

     BUG: spinlock lockup on CPU#1, swapper/0, e9bcb200

     Nothing else. No call trace, no cpu registers dump. Just this
     line. Any hints?

-- 
wbr,
 Oleg                            mailto:sysoleg@progtech.ru

