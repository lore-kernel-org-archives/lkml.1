Return-Path: <linux-kernel-owner+w=401wt.eu-S1751911AbXE2XR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbXE2XR6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 19:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbXE2XRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 19:17:51 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56675 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751168AbXE2XRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 19:17:50 -0400
Date: Tue, 29 May 2007 16:17:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "young dave" <hidave.darkstar@gmail.com>
Cc: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [patch -mm 1/1] remove useless tolower in isofs
Message-Id: <20070529161737.a19af5e6.akpm@linux-foundation.org>
In-Reply-To: <a8e1da0705272011g6ad2550eo153eb0e98590b11a@mail.gmail.com>
References: <a8e1da0705271808w3a6dc453rfb47dd3db100718@mail.gmail.com>
	<alpine.DEB.0.99.0705272248110.6131@sigma.j-a-k-j.com>
	<a8e1da0705272011g6ad2550eo153eb0e98590b11a@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 May 2007 03:11:04 +0000
"young dave" <hidave.darkstar@gmail.com> wrote:

> Hi,
> > And then there's the supercompact form.
> >
> > while (len--) {
> >         hash = partial_name_hash(tolower(*name++), hash);
> > }
> >
> > But I do not like the last one at all. The first one is the best, because
> > it clearly separates the condition and iteration parts of the expression,
> > while STILL being only three lines long. Or two, if you omit the braces.
> > (But you shouldn't.)
> >
> 
> IMO, I like the last one, but I prefer to keep the original author's
> one, I only remove the unnecessary tolower function.
> What do you think about this , Andrew?
> 

Don't care much.  The code as it stands is suitably paranoid about 
buggy implementations of tolower() which evaluate their arg more
than once ;)

Your email client replaces tabs with spaces.
