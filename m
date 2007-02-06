Return-Path: <linux-kernel-owner+w=401wt.eu-S1752315AbXBFVcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbXBFVcH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 16:32:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933225AbXBFVcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 16:32:07 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49653
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752315AbXBFVcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 16:32:05 -0500
Date: Tue, 06 Feb 2007 13:31:40 -0800 (PST)
Message-Id: <20070206.133140.91442326.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: kent.overstreet@gmail.com, davidel@xmailserver.org, zach.brown@oracle.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       suparna@in.ibm.com, bcrl@kvack.org
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0702061325380.8424@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702061238300.8424@woody.linux-foundation.org>
	<20070206.131631.82049180.davem@davemloft.net>
	<Pine.LNX.4.64.0702061325380.8424@woody.linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 6 Feb 2007 13:28:34 -0800 (PST)

> Yeah, in 1% of all cases it will block, and you'll want to wait for them. 
> Maybe the kevent queue works then, but if it needs any more setup than the 
> nonblocking case, that's a big no.

So the idea is to just run it to completion if it won't block and use
a fibril if it would?

kevent could support something like that too.
