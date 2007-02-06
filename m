Return-Path: <linux-kernel-owner+w=401wt.eu-S965463AbXBFVuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965463AbXBFVuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 16:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965544AbXBFVuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 16:50:40 -0500
Received: from smtp.osdl.org ([65.172.181.24]:52527 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965463AbXBFVuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 16:50:39 -0500
Date: Tue, 6 Feb 2007 13:50:02 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: kent.overstreet@gmail.com, davidel@xmailserver.org, zach.brown@oracle.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       suparna@in.ibm.com, bcrl@kvack.org
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
In-Reply-To: <20070206.133140.91442326.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0702061348160.8424@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702061238300.8424@woody.linux-foundation.org>
 <20070206.131631.82049180.davem@davemloft.net>
 <Pine.LNX.4.64.0702061325380.8424@woody.linux-foundation.org>
 <20070206.133140.91442326.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Feb 2007, David Miller wrote:
> 
> So the idea is to just run it to completion if it won't block and use
> a fibril if it would?

That's not how the patches work right now, but yes, I at least personally 
think that it's something we should aim for (ie the interface shouldn't 
_require_ us to always wait for things even if perhaps an early 
implementation might make everything be delayed at first)

			Linus
