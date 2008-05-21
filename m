Return-Path: <linux-kernel-owner+w=401wt.eu-S936682AbYEUTco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936682AbYEUTco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 15:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932126AbYEUTcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 15:32:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56294 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759406AbYEUTcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 15:32:19 -0400
Date: Wed, 21 May 2008 12:31:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: tytso@mit.edu, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: CFD: linux-wanking@vger.kernel.org (was [PATCH] Standard
 indentation of arguments)
Message-Id: <20080521123127.3b3b66af.akpm@linux-foundation.org>
In-Reply-To: <20080521185725.GD6932@cvg>
References: <12113495282137-git-send-email-kongjianjun@gmail.com>
	<20080521083413.GM28946@ZenIV.linux.org.uk>
	<20080521015037.add0b78e.akpm@linux-foundation.org>
	<20080521103206.GA24545@infradead.org>
	<20080521120939.GF8581@mit.edu>
	<20080521104644.5b6f4e63.akpm@linux-foundation.org>
	<20080521185725.GD6932@cvg>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 22:57:25 +0400
Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Btw, we have CodingStyle, SubmittingPatches and other, but why don't
> we have something like KernelNewbieGuide? Don't get me wrong, but
> there could be written all rules about - what is good to do, what is bad.
> So a newbiew who wants to be usefull for kernel could read it and decide
> what should be done. /Don't beat me ;) / And of course I know about
> kernelnewbie.org but this (even quite short) document could help I think.

There are a lot of people out there who would like to try their hands
at kernel.org development but who just aren't sure how to start, nor
where to start.

One could understand a developer deciding to write a do-nothing
whitespace patch as a general throat-clearing exercise, but when asked,
I recommend against that.  I generally recommend that people just
download and test the latest -rc, linux-next and -mm kernels and build
and run them.  Because they surely will find things which need fixing. 
Often simple little things like compilation errors, sometimes things
which need a bisection search.

For more substantial starter projects the best we have (as far as I
know) is http://kernelnewbies.org/KernelProjects, but that's just a
teeny subset.

We're not very good at this, I'm afraid.  I seem to recall that Rik has
offered to help out here, so perhaps whenever one notices a
hey-someone-should-do-this project, it could be forwarded to Rik and he
can put it up there.

The #1 project for all kernel beginners should surely be "make sure
that the kernel runs perfectly at all times on all machines which you
can lay your hands on".  Usually the way to do this is to work with
others on getting things fixed up (this can require persistence!) but
that's fine - it's a part of kernel development.

