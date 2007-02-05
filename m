Return-Path: <linux-kernel-owner+w=401wt.eu-S933473AbXBEVoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933473AbXBEVoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 16:44:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933478AbXBEVoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 16:44:44 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50126
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933473AbXBEVon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 16:44:43 -0500
Date: Mon, 05 Feb 2007 13:44:42 -0800 (PST)
Message-Id: <20070205.134442.85686980.davem@davemloft.net>
To: davidel@xmailserver.org
Cc: zach.brown@oracle.com, mingo@elte.hu, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-aio@kvack.org, suparna@in.ibm.com,
       bcrl@kvack.org
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0702051022170.14453@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0702021525370.5219@alien.or.mcafeemobile.com>
	<EDD3B5A9-9EAB-4E0A-BE1F-3B73C3870DC8@oracle.com>
	<Pine.LNX.4.64.0702051022170.14453@alien.or.mcafeemobile.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Libenzi <davidel@xmailserver.org>
Date: Mon, 5 Feb 2007 10:24:34 -0800 (PST)

> Yes, no need for the above. We can just host a poll/epoll in an async() 
> operation, and demultiplex once that gets ready.

I can hear Evgeniy crying 8,000 miles away.

I strongly encourage a lot of folks commenting in this thread to
familiarize themselves with kevent and how it handles this stuff.  I
see a lot of suggestions for things he has totally implemented and
solved already in kevent.

I'm not talking about Zach's fibril's, I'm talking about the interface
aspects of these discussions.
