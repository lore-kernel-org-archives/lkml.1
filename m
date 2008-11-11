Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbYKKXtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbYKKXtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 18:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbYKKXtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 18:49:05 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56701
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751997AbYKKXtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 18:49:03 -0500
Date: Tue, 11 Nov 2008 15:49:02 -0800 (PST)
Message-Id: <20081111.154902.11426409.davem@davemloft.net>
To: a.beregalov@gmail.com
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
       kernel-testers@vger.kernel.org, rjw@sisk.pl
Subject: Re: 2.6.28-rc4: BUG: spinlock lockup on CPU#0
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081111233230.GC12456@orion>
References: <20081111233230.GC12456@orion>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Beregalov <a.beregalov@gmail.com>
Date: Wed, 12 Nov 2008 02:32:30 +0300

> It is on sparc64 (Ultra 10). 2.6.28-rc4-00011-g3ad4f59
> 
> BUG: spinlock lockup on CPU#0, metalog/1322, 00000000007f1430
> Kernel panic - not syncing: Aiee, killing interrupt handler!
> 
> It seems Sysrq does not work.
> 
> David, how can I provide more info before I reboot it ?
> 
> Full dmesg:

Hmm, this BUG message should have given you a register dump and a
backtrace.

Can you give it a "Alt-SysRQ-p" and show the output?

Actually, if you got this over a serial console or
similar, you're not getting the register dump because
the console loglevel is filtering them out.

If that's what's happening, reboot with "ignore_loglevel"
(I always boot with this option, by adding it to the
default kernel command line options in /etc/silo.conf)

Also, in situations where the system is already booted and
you want to see things like the Alt-SysRQ-p register dumps
on the console, you'll need to type something like
"Alt-SysRQ-8" to bump the console log level.
