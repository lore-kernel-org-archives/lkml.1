Return-Path: <linux-kernel-owner+w=401wt.eu-S1754191AbZASAIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbZASAIy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 19:08:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbZASAIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 19:08:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:57273 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904AbZASAIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 19:08:38 -0500
Date: Sun, 18 Jan 2009 16:10:41 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, dst@ioremap.net,
       David Howells <dhowells@redhat.com>
Subject: Re: [4/7] dst: thread pool.
Message-ID: <20090118161041.40608174@infradead.org>
In-Reply-To: <20090114215810.674569fc.akpm@linux-foundation.org>
References: <1231887933-17843-1-git-send-email-zbr@ioremap.net>
	<1231887933-17843-2-git-send-email-zbr@ioremap.net>
	<1231887933-17843-3-git-send-email-zbr@ioremap.net>
	<1231887933-17843-4-git-send-email-zbr@ioremap.net>
	<1231887933-17843-5-git-send-email-zbr@ioremap.net>
	<20090114215810.674569fc.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009 21:58:10 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> > Thread pool is used for crypto processing of incoming and outgoing
> > IO requests to reduce the overall overhead.
> 
> This is at least our fourth thread pool implementation, not counting
> kernel/workqueue.c:
>  
> 1: pdflush

I will look at moving pdflush to async function calls.. sounds like a
good "get over jetlag" project

> 
> 2: David Howells' "slow work" infrastructure

this one is *weird*. The infrastructure deals with object refcounting
somehow. 

> 
> 4: Your "dst thread pool"

from the context... I wouldn't be surprised if this can just use async
function calls as well... it's simple enough on first sight.

--
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
