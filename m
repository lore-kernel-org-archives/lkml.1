Return-Path: <linux-kernel-owner+w=401wt.eu-S1030762AbXCHWLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030762AbXCHWLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 17:11:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030764AbXCHWLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 17:11:34 -0500
Received: from smtp.osdl.org ([65.172.181.24]:38957 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030762AbXCHWLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 17:11:33 -0500
Date: Thu, 8 Mar 2007 14:11:08 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@argo.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/5] signalfd v2 - signalfd core ...
In-Reply-To: <20070308215653.GA6744@tv-sign.ru>
Message-ID: <Pine.LNX.4.64.0703081410180.10832@woody.linux-foundation.org>
References: <20070308204353.GA6733@tv-sign.ru>
 <Pine.LNX.4.64.0703081259560.7515@alien.or.mcafeemobile.com>
 <20070308215653.GA6744@tv-sign.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 Mar 2007, Oleg Nesterov wrote:
> 
> Also. A malicious user can eat all memory, signalfd_deliver()->kmem_cache_alloc()
> doesn't check any limits.

This, btw, is one reason I *really* think signalfd() should just use the 
same old signal queue, and not try to make its own.

Signal queueing and unqueuing simply isn't that simple. 

		Linus
