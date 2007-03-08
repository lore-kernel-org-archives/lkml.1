Return-Path: <linux-kernel-owner+w=401wt.eu-S1030854AbXCHW7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030854AbXCHW7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 17:59:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030856AbXCHW7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 17:59:13 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:43927 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030854AbXCHW7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 17:59:11 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 8 Mar 2007 14:59:08 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       Avi Kivity <avi@argo.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/5] signalfd v2 - signalfd core ...
In-Reply-To: <Pine.LNX.4.64.0703081410180.10832@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703081458190.4882@alien.or.mcafeemobile.com>
References: <20070308204353.GA6733@tv-sign.ru>
 <Pine.LNX.4.64.0703081259560.7515@alien.or.mcafeemobile.com>
 <20070308215653.GA6744@tv-sign.ru> <Pine.LNX.4.64.0703081410180.10832@woody.linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2007, Linus Torvalds wrote:

> 
> 
> On Fri, 9 Mar 2007, Oleg Nesterov wrote:
> > 
> > Also. A malicious user can eat all memory, signalfd_deliver()->kmem_cache_alloc()
> > doesn't check any limits.
> 
> This, btw, is one reason I *really* think signalfd() should just use the 
> same old signal queue, and not try to make its own.
> 
> Signal queueing and unqueuing simply isn't that simple. 

Alrighty. Back to the dequeue_signal ...



- Davide


