Return-Path: <linux-kernel-owner+w=401wt.eu-S1762694AbXIKRWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762694AbXIKRWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 13:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755334AbXIKRWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 13:22:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43239 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbXIKRWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 13:22:40 -0400
Date: Tue, 11 Sep 2007 19:22:19 +0100
From: Arjan van de Ven <arjan@infradead.org>
To: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Do not deprecate binary semaphore or do allow mutex in software
 interrupt contexts
Message-ID: <20070911192219.2e089493@laptopd505.fenrus.org>
In-Reply-To: <36061.50670.qm@web52002.mail.re2.yahoo.com>
References: <36061.50670.qm@web52002.mail.re2.yahoo.com>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007 09:20:23 -0700 (PDT)
Matti Linnanvuori <mattilinnanvuori@yahoo.com> wrote:

>  Arjan van de Ven:
> > what do you do if the trylock fails?
> 
> Just do not read the status variable now but modify the timer to run
> later.
> 
> > to be honest, the scenario describe really smells of broken
> > locking, in fact it really sounds like it wants to use spinlocks
> > instead 
> 
> No, I don't think it is broken.
> Spinlocks can be used, but I don't see them being obviously better in
> all cases. If access takes a long time, it is better to sleep during
> it. And if you sleep, you might just end up creating a new mutex
> implementation with a spinlock.


at this point the discussion has gone so theoretical that I think it's
better to go with a real example. What actual source code do you think
is a legit case for this?

I still think that whatever case you have in mind is better served with
something else, but until we see the actual complete drier we're both
talking air.
