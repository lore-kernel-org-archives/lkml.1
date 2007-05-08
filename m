Return-Path: <linux-kernel-owner+w=401wt.eu-S966436AbXEHKVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966436AbXEHKVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 06:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934637AbXEHKVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 06:21:46 -0400
Received: from stinky.trash.net ([213.144.137.162]:47214 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934633AbXEHKVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 06:21:46 -0400
Message-ID: <46404EC4.4010303@trash.net>
Date: Tue, 08 May 2007 12:19:48 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: 2.6.21-git8+ BUG: NMI Watchdog detected LOCKUP on CPU1
References: <46403642.7020501@googlemail.com> <20070508030701.d21dc40b.akpm@linux-foundation.org>
In-Reply-To: <20070508030701.d21dc40b.akpm@linux-foundation.org>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Whatever happens, that printk should be toned down, shouldn't it?  We
> prefer to not let unprivileged apps spam the logs.


Only priviledged apps can send these packets. I've never seen it in
practice except for one case that was a bug in the network stack, so
I'd prefer to keep it. The original intention was to give the user
a hint why these packets are not affected by iptables rules, so a
more descriptive message would make sense. I'll queue a patch for
this.

