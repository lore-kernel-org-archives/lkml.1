Return-Path: <linux-kernel-owner+w=401wt.eu-S1761370AbYDNXTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761370AbYDNXTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 19:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755020AbYDNXTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 19:19:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50910 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752286AbYDNXTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 19:19:21 -0400
Date: Mon, 14 Apr 2008 16:05:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: jmorris@namei.org, viro@ZenIV.linux.org.uk, w@1wt.eu, david@lang.hm,
       sclark46@earthlink.net, johnpol@2ka.mipt.ru, rjw@sisk.pl,
       tilman@imap.cc, Valdis.Kletnieks@vt.edu, lkml@rtr.ca,
       jesper.juhl@gmail.com, yoshfuji@linux-ipv6.org, jeff@garzik.org,
       linux-kernel@vger.kernel.org, git@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Reporting bugs and bisection
Message-Id: <20080414160513.9f57e5ba.akpm@linux-foundation.org>
In-Reply-To: <20080414.150105.101568769.davem@davemloft.net>
References: <20080413232441.e216a02c.akpm@linux-foundation.org>
	<20080414072328.GW9785@ZenIV.linux.org.uk>
	<Xine.LNX.4.64.0804150131300.4160@us.intercode.com.au>
	<20080414.150105.101568769.davem@davemloft.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 15:01:05 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: James Morris <jmorris@namei.org>
> Date: Tue, 15 Apr 2008 01:54:00 +1000 (EST)
> 
> > - Things like "who made the kernel" statistics and related articles ignore 
> >   code review.
> 
> Note the apparent irony in that the person who ends up often on the
> top of those lists, Al Viro, is also someone who also does a
> significant amount of code review.
> 
> I think this is no accident.

"who made the kernel" was an interesting and useful exercise, but if you
like irony then...

- The way to boost your commit count is to submit buggy patches and to
  then fix your own bugs.

- The way to lower your commit count is to fix things in other people's
  patches, then fold your fix into the base patch.  I've lost over 1000
  commits that way.  Unless they are counting '^    [akpm' as a commit.
