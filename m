Return-Path: <linux-kernel-owner+w=401wt.eu-S1754075AbYJ2A3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbYJ2A3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 20:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbYJ2A3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 20:29:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52019 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751955AbYJ2A3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 20:29:13 -0400
Date: Tue, 28 Oct 2008 17:28:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Newall <davidn@davidnewall.com>
Cc: jianjun@zeuux.org, cl@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fork.c: fix a problem of code style
Message-Id: <20081028172859.5986359b.akpm@linux-foundation.org>
In-Reply-To: <48FE0415.70700@davidnewall.com>
References: <20081021141647.GA12090@ubuntu>
	<48FE0415.70700@davidnewall.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008 03:02:21 +1030
David Newall <davidn@davidnewall.com> wrote:

> Jianjun Kong wrote:
> > -	if(max_threads < 20)
> > +	if (max_threads < 20)
> 
> I thought we didn't bother with trivial style changes like this.

Yes, it's too small:

akpm:/usr/src/25> perl scripts/checkpatch.pl --file kernel/fork.c | grep total
total: 34 errors, 13 warnings, 1689 lines checked

We could merge thousands and thousand of one-line patches like this and
it's all very inefficient.

I'd consider larger patches which cleaned up whole subdirectories. 
They're not much fun to maintain but we don't regret these things after
we've done them.


