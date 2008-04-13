Return-Path: <linux-kernel-owner+w=401wt.eu-S1757715AbYDMXLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715AbYDMXLU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 19:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757408AbYDMXLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 19:11:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39339 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757267AbYDMXLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 19:11:02 -0400
Date: Sun, 13 Apr 2008 16:10:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>, Miklos Szeredi <miklos@szeredi.hu>,
       hch@infradead.org, me@bobcopeland.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Message-Id: <20080413161014.cb06964c.akpm@linux-foundation.org>
In-Reply-To: <20080413234920.63711ca7@core>
References: <1208041121-26787-1-git-send-email-me@bobcopeland.com>
	<20080412170304.54f139e2.akpm@linux-foundation.org>
	<20080413033344.GA27494@hash.localnet>
	<20080412205544.5e12a7d4.akpm@linux-foundation.org>
	<20080413080130.GA9622@infradead.org>
	<20080413012001.8d7967f4.akpm@linux-foundation.org>
	<20080413082815.GA20108@infradead.org>
	<E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu>
	<1208121358.2700.4.camel@shinybook.infradead.org>
	<20080413154459.4b2f125d.akpm@linux-foundation.org>
	<20080413234920.63711ca7@core>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2008 23:49:20 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > I guess I can keep making this point in various ways until someone
> > actually notices it:
> > 
> > 	This filesystem has only 20 users.
> 
> At the moment. And that probably exceeds Amiga users, 386 users, some of
> the serial port users, several network card users ...
> 
> In the past we've merged drivers for network cards where only two
> existed in the world. Linus has repeatedly stated he wants to see stuff
> people are using getting in.

None of that means that merging this filesystem is the best decision.

> Good clean code that doesn't affect the core
> is good reference material.

The reference block filesystem is ext2 (used to be minixfs) - there is no
need for another.

> I think you are (unusually) the one out of step here ?

I appear to be the only one who is looking at the whole picture.

Merging a new filesystem has costs - I don't need to enumerate them.  Do
the benefits of OMFS exceed them?
