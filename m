Return-Path: <linux-kernel-owner+w=401wt.eu-S1752548AbYLOIUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbYLOIUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 03:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbYLOIUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 03:20:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48771
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752125AbYLOIUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 03:20:18 -0500
Date: Mon, 15 Dec 2008 00:20:19 -0800 (PST)
Message-Id: <20081215.002019.232912990.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       mingo@elte.hu, akpm@linux-foundation.org, acme@ghostprotocols.net
Subject: Re: [PATCH] update rwlock initialization for nat_table
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.1.10.0812101504280.11805@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0812101314460.11805@gandalf.stny.rr.com>
	<49400B7F.7040607@cosmosbay.com>
	<alpine.DEB.1.10.0812101504280.11805@gandalf.stny.rr.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Wed, 10 Dec 2008 15:06:00 -0500 (EST)

>     update rwlock initialization for nat_table
>     
>     Impact: clean up
>     
>     The commit e099a173573ce1ba171092aee7bb3c72ea686e59
>     (netfilter: netns nat: per-netns NAT table) renamed the
>     nat_table from __nat_table to nat_table without updating the
>     __RW_LOCK_UNLOCKED(__nat_table.lock).
>     
>     Signed-off-by: Steven Rostedt <srostedt@redhat.com>

Applied to net-2.6, thanks Steven.

As Andrew mentioned this is a bug (albeit a "nano-bug" as you
called it :-) so I removed the Impact line in the commit
message when applying this.

Thanks!
