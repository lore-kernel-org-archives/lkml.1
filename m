Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbXD0EMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbXD0EMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 00:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755277AbXD0EMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 00:12:41 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755281AbXD0EMk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 00:12:40 -0400
Date: Thu, 26 Apr 2007 21:11:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vincent ETIENNE <ve@vetienne.net>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, fubar@us.ibm.com,
       bonding-devel@lists.sourceforge.net
Subject: Re: [PROBLEM] Bonding driver in linux-2.6.21-rc6-mm1
Message-Id: <20070426211146.f370cf81.akpm@linux-foundation.org>
In-Reply-To: <200704262058.33087.ve@vetienne.net>
References: <200704262058.33087.ve@vetienne.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007 20:58:32 +0200 Vincent ETIENNE <ve@vetienne.net> wrote:

> 		Apr 26 11:09:34 jupiter2 RTNL: assertion failed at net/ipv4/devinet.c
> 		(1055) Apr 26 11:09:34 jupiter2
> 		Apr 26 11:09:34 jupiter2 Call Trace:
> 		Apr 26 11:09:34 jupiter2 <IRQ>  [<ffffffff8049b49e>] 
> inetdev_event+0x48/0x283
> 		Apr 26 11:09:34 jupiter2 [<ffffffff804c8731>] _spin_lock_bh+0x9/0x19
> 		Apr 26 11:09:34 jupiter2 [<ffffffff80473df1>] rt_run_flush+0x7e/0xaf
> 		Apr 26 11:09:34 jupiter2 [<ffffffff8022bdd0>] notifier_call_chain+0x29/0x56 
> 		Apr 26 11:09:34 jupiter2 [<ffffffff804560cc>] dev_set_mac_address+0x53/0x59 			
> 		Apr 26 11:09:34 jupiter2 [<ffffffff88006d8d>] 
> bo

This was due to locking bustage in the net tree.  It should be fixed in 2.6.21-rc7-mm2.
