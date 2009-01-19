Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbZASAhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbZASAhS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 19:37:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754769AbZASAhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 19:37:04 -0500
Received: from casper.infradead.org ([85.118.1.10]:36217 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365AbZASAhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 19:37:02 -0500
Date: Sun, 18 Jan 2009 16:39:12 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] async: Add some documentation.
Message-ID: <20090118163912.55f835a0@infradead.org>
In-Reply-To: <20090114112450.1a1af271@gondolin>
References: <20090113174306.0f620476@gondolin>
	<20090114024952.GS8071@disturbed>
	<20090114112450.1a1af271@gondolin>
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

On Wed, 14 Jan 2009 11:24:50 +0100
Cornelia Huck <cornelia.huck@de.ibm.com> wrote:

> > Rather than polishing a turd, can we rename this "special" stuff to
> > something more descriptive? I'm not the only person to complain
> > about this. How about async_schedule_list()?
> > 
> > After all, async_schedule_list() describes *exactly* how it is
> > different to async_schedule(), while the "_special" keywords really
> > suck when you consider code is supposed to be self documenting....
> 
> async_schedule_list() sounds better, agreed, but I'd prefer to change
> that in a seperate patch.

I had it as that at first. But it is ugly; naming a function after its
arguments is useless; it should be named after what it does instead.

I buy that "special" is not a good name. Would "local" be better?
The name needs to convey that it is for a specific synchronization
context....


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
