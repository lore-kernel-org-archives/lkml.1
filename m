Return-Path: <linux-kernel-owner+w=401wt.eu-S1767253AbXDEULs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767253AbXDEULs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 16:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767278AbXDEULs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 16:11:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56757
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1767253AbXDEULr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 16:11:47 -0400
Date: Thu, 05 Apr 2007 13:11:44 -0700 (PDT)
Message-Id: <20070405.131144.85410010.davem@davemloft.net>
To: mingo@elte.hu
Cc: nakagawa.msy@ncos.nec.co.jp, linux-kernel@vger.kernel.org, bunk@stusta.de
Subject: Re: [PATCH 2.6.21-rc5-rt12] IPV6: Flag bit of ebitmask is not set
 in __inet6_hash.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070405190714.GB22092@elte.hu>
References: <461543B5.6080605@ncos.nec.co.jp>
	<20070405190714.GB22092@elte.hu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 5 Apr 2007 21:07:14 +0200

> * Masayuki Nakagawa <nakagawa.msy@ncos.nec.co.jp> wrote:
> 
> > I found an issue with -rt patch. It is that netstat doesn't show IPv6 
> > sockets in ESTABLISHED state. This issue happens because a flag bit of 
> > ebitmask is not set when the IPv6 socket connection is established.
> > 
> > The fix is to set the flag bit in __inet6_hash().
> 
> thanks. I'm wondering, should this fix be done in mainline too? -rt12 is 
> based on Linus' -git kernel from yesterday.

I don't see any of this bitmap stuff in my net-2.6.22 tree.

Also, because I figured that the patch was some -rt specific
fix I deleted the original patch so I can't even double check.
:-)
