Return-Path: <linux-kernel-owner+w=401wt.eu-S1760808AbYDNIqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760808AbYDNIqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 04:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757502AbYDNIqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 04:46:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41259 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757277AbYDNIqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 04:46:06 -0400
Date: Mon, 14 Apr 2008 01:44:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Xavier Bestel <xavier.bestel@free.fr>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Woodhouse <dwmw2@infradead.org>,
       Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org,
       me@bobcopeland.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Message-Id: <20080414014445.5b4a7b22.akpm@linux-foundation.org>
In-Reply-To: <1208161859.3596.75.camel@skunk.anacadf.mentorg.com>
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
	<1208161859.3596.75.camel@skunk.anacadf.mentorg.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 10:30:59 +0200 Xavier Bestel <xavier.bestel@free.fr> wrote:

> On Sun, 2008-04-13 at 16:10 -0700, Andrew Morton wrote:
> > I appear to be the only one who is looking at the whole picture.
> > 
> > Merging a new filesystem has costs - I don't need to enumerate them.  Do
> > the benefits of OMFS exceed them?
> 
> Eh you, corporate linux developer, please don't discriminate what's
> going in the kernel just because of extra cost.

By "cost" I refer to extra developer time spent on maintaining the
filesystem.  The most recent example is the write_begin/write_end changes
which took a lot of Nick's time and rather a lot of mine also.

I get to see these costs.  I seek to minimise them.

> Let linux continue to be
> "by the people, for the people" if you see what I mean.

"the people" here are those who work on the kernel.  We want our time to be
spent as effectively as possible.  Sorry if that sounds corporate.
