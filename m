Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377Ab0BOT5d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 14:57:33 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:39852 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756294Ab0BOT5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 14:57:32 -0500
Date: Mon, 15 Feb 2010 19:57:28 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/4] Check O_* flags set with fcntl() on anon_inode
 files.
Message-ID: <20100215195728.GX30031@ZenIV.linux.org.uk>
References: <1266107267-5920-1-git-send-email-matthltc@us.ibm.com>
 <20100214035205.GU30031@ZenIV.linux.org.uk>
 <20100215172635.GI3714@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100215172635.GI3714@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 09:26:35AM -0800, Matt Helsley wrote:
> > > [PATCH 1/4] signalfd
> > > [PATCH 2/4] timerfd
> > > [PATCH 3/4] epoll
> > > [PATCH 4/4] eventfd
> > > 
> > > I did not check the perf, kvm-vm, or kvm-vcpu uses of anon_inodes.
> > 
> > Er...  O_ASYNC is silently ignored for regular files as well, so any
> > userland code that tries to rely on fcntl() rejecting it is and always
> > had been badly b0rken.
> 
> Of course. Did you mean to imply that the kernel shouldn't bother to
> reject these, or were you merely making an observation?

I'm wondering why should we start changing that behaviour and what makes
these 4 cases special?
