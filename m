Return-Path: <linux-kernel-owner+w=401wt.eu-S965490AbXBFVQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965490AbXBFVQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 16:16:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965499AbXBFVQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 16:16:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42404
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S965490AbXBFVQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 16:16:33 -0500
Date: Tue, 06 Feb 2007 13:16:31 -0800 (PST)
Message-Id: <20070206.131631.82049180.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: kent.overstreet@gmail.com, davidel@xmailserver.org, zach.brown@oracle.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       suparna@in.ibm.com, bcrl@kvack.org
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0702061238300.8424@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702051259030.14453@alien.or.mcafeemobile.com>
	<6f703f960702051331v3ceab725h68aea4cd77617f84@mail.gmail.com>
	<Pine.LNX.4.64.0702061238300.8424@woody.linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 6 Feb 2007 12:46:11 -0800 (PST)

> And for user space, it means that we pass the _one_ thing around that we 
> need for both identifying the async operation to the kernel (the "cookie") 
> for wait or cancel, and the place where we expect the return value to be 
> found (which in turn can _easily_ represent a whole "struct aiocb *", 
> since the return value obviously has to be embedded in there anyway).

I really think that Evgeniy's kevent is a good event notification
mechanism for anything, including AIO.

Events are events, applications want a centralized way to receive and
process them.

It's already implemented, and if there are tangible problems with it,
Evgeniy has been excellent at responding to criticism and implementing
suggested changes to the interfaces.
