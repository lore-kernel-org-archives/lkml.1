Return-Path: <linux-kernel-owner+w=401wt.eu-S965613AbXFFW5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965613AbXFFW5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935738AbXFFW5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:57:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43398
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S935589AbXFFW5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:57:31 -0400
Date: Wed, 06 Jun 2007 15:57:47 -0700 (PDT)
Message-Id: <20070606.155747.31642197.davem@davemloft.net>
To: davidel@xmailserver.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, drepper@redhat.com, mingo@elte.hu,
       dada1@cosmosbay.com
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0706061549110.10383@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7>
	<20070606.154434.21926922.davem@davemloft.net>
	<Pine.LNX.4.64.0706061549110.10383@alien.or.mcafeemobile.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Libenzi <davidel@xmailserver.org>
Date: Wed, 6 Jun 2007 15:52:31 -0700 (PDT)

> I have no huge preferences. If not the slight one of using the same flags 
> for open() and socket{2}() (O_NONSEQFD). If we overload socket() we may 
> need to fight with existing O_* flags. OTOH the current free ones are 
> pretty high in bits, so it may be OK too.

I see.

To me this tends to give higher weight to just adding the
new socket2() system call.
