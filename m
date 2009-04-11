Return-Path: <linux-kernel-owner+w=401wt.eu-S1756795AbZDKIph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbZDKIph (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 04:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858AbZDKIpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 04:45:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42511
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754415AbZDKIpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 04:45:22 -0400
Date: Sat, 11 Apr 2009 01:45:10 -0700 (PDT)
Message-Id: <20090411.014510.196493199.davem@davemloft.net>
To: vladislav.yasevich@hp.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv6: Fix NULL pointer dereference with time-wait
 sockets
From: David Miller <davem@davemloft.net>
In-Reply-To: <1239334653-5412-1-git-send-email-vladislav.yasevich@hp.com>
References: <200904072206.29396.edt@aei.ca>
	<1239334653-5412-1-git-send-email-vladislav.yasevich@hp.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu,  9 Apr 2009 23:37:33 -0400

> Commit b2f5e7cd3dee2ed721bf0675e1a1ddebb849aee6
> (ipv6: Fix conflict resolutions during ipv6 binding)
> introduced a regression where time-wait sockets were
> not treated correctly.  This resulted in the following:
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000062
> IP: [<ffffffff805d7d61>] ipv4_rcv_saddr_equal+0x61/0x70
> ...
> Call Trace:
> [<ffffffffa033847b>] ipv6_rcv_saddr_equal+0x1bb/0x250 [ipv6]
> [<ffffffffa03505a8>] inet6_csk_bind_conflict+0x88/0xd0 [ipv6]
> [<ffffffff805bb18e>] inet_csk_get_port+0x1ee/0x400
> [<ffffffffa0319b7f>] inet6_bind+0x1cf/0x3a0 [ipv6]
> [<ffffffff8056d17c>] ? sockfd_lookup_light+0x3c/0xd0
> [<ffffffff8056ed49>] sys_bind+0x89/0x100
> [<ffffffff80613ea2>] ? trace_hardirqs_on_thunk+0x3a/0x3c
> [<ffffffff8020bf9b>] system_call_fastpath+0x16/0x1b
> 
> Tested-by: Brian Haley <brian.haley@hp.com>
> Tested-by: Ed Tomlinson <edt@aei.ca>
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied, thanks Vlad.
