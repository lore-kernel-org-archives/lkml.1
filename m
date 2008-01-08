Return-Path: <linux-kernel-owner+w=401wt.eu-S1754797AbYAHWuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbYAHWuz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:50:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbYAHWuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:50:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55338
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751452AbYAHWup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:50:45 -0500
Date: Tue, 08 Jan 2008 14:50:38 -0800 (PST)
Message-Id: <20080108.145038.203528847.davem@davemloft.net>
To: m.kozlowski@tuxland.pl
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7: sparc64: WARNING: at
 kernel/lockdep_proc.c:267 lockdep_stats_show()
From: David Miller <davem@davemloft.net>
In-Reply-To: <200801081942.17139.m.kozlowski@tuxland.pl>
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>
	<200801081942.17139.m.kozlowski@tuxland.pl>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Date: Tue, 8 Jan 2008 19:42:16 +0100

> Hello,
> 
> 	Got this when doing usual looping over /proc entries on fresh test kernel:
> 
> WARNING: at kernel/lockdep_proc.c:267 lockdep_stats_show()
> Call Trace:
>  [0000000000492704] lockdep_stats_show+0x6ac/0x6c0
>  [00000000004eb4b4] seq_read+0x5c/0x340
>  [000000000050b2bc] proc_reg_read+0x64/0xa0
>  [00000000004cd72c] vfs_read+0x74/0x120
>  [00000000004cdb4c] sys_read+0x34/0x60
>  [00000000004062d4] linux_sparc_syscall32+0x3c/0x40
>  [0000000000012ff4] 0x12ffc

Please turn off lockdep on sparc64, currently it not
reliable.  I have many things to audit, including how
the stack frames are presented to the lockdep layer.

So any problem you run into can be due to issues like
that.
