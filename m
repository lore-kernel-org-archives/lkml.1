Return-Path: <linux-kernel-owner+w=401wt.eu-S1760430AbYDNIhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760430AbYDNIhV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 04:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757494AbYDNIhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 04:37:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756782AbYDNIhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 04:37:03 -0400
Date: Mon, 14 Apr 2008 01:36:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>, Miklos Szeredi <miklos@szeredi.hu>,
       hch@infradead.org, me@bobcopeland.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Message-Id: <20080414013600.25a8fae9.akpm@linux-foundation.org>
In-Reply-To: <20080414091639.4bd3879d@core>
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
	<20080413161014.cb06964c.akpm@linux-foundation.org>
	<20080414091639.4bd3879d@core>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 09:16:39 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > I appear to be the only one who is looking at the whole picture.
> > 
> > Merging a new filesystem has costs - I don't need to enumerate them.  Do
> > the benefits of OMFS exceed them?
> 
> I think the exceed them quite easily. The costs are almost nil,

They're modest, but they're there.

> while
> merging this provides another nice example fs (and one much easier to
> follow than ext*) for hardware that does have a few users and will no
> doubt get many more
> 
> I wasn't aware Linus had introduced a new rule required 500 people sign
> up to use a feature before it gets added ?

He doesn't need to.

We'll frequently add features in the expectation that they will be useful
to a significant part of our user base.  It's a part of the decision-making
process.

Many features will have a small number of users initialy, but that grows
over time.  otoh, OMFS's user base is small and it appears that it will
dwindle.

(And in the past Linus has set the bar *much* higher for new filesystems
than I have..)
