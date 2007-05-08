Return-Path: <linux-kernel-owner+w=401wt.eu-S934873AbXEHQJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934873AbXEHQJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 12:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934771AbXEHQJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 12:09:54 -0400
Received: from twin.jikos.cz ([213.151.79.26]:54511 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934567AbXEHQJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 12:09:53 -0400
Date: Tue, 8 May 2007 18:09:42 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.21-git8+ BUG: NMI Watchdog detected LOCKUP on CPU1
In-Reply-To: <20070508030701.d21dc40b.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705081807100.16923@twin.jikos.cz>
References: <46403642.7020501@googlemail.com> <20070508030701.d21dc40b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007, Andrew Morton wrote:

>   happens when a local process sends packets with invalid IP headers
>   through raw sockets.
[...]
> Whatever happens, that printk should be toned down, shouldn't it?  We
> prefer to not let unprivileged apps spam the logs.

Isn't "unprivileged app sending packet through raw socket" an oxymoron? As 
Patrick pointed out, the message is there for a reason, I'd suggest using 
printk_ratelimit() in this case.

-- 
Jiri Kosina
