Return-Path: <linux-kernel-owner+w=401wt.eu-S1752524AbYL3NFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbYL3NFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 08:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbYL3NFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 08:05:42 -0500
Received: from verein.lst.de ([213.95.11.210]:56100 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515AbYL3NFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 08:05:41 -0500
Date: Tue, 30 Dec 2008 14:04:39 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Al@oss.sgi.com, Oleg Nesterov <oleg@redhat.com>, bfields@fieldses.org,
       xfs-masters@oss.sgi.com, Viro <viro@ZenIV.linux.org.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [xfs-masters] RFC: Fix f_flags races without the BKL
Message-ID: <20081230130439.GA28874@lst.de>
References: <20081229041352.6bbdf57c@tpl> <20081229124151.GA29634@redhat.com> <20081229152732.GH496@one.firstfloor.org> <20081230055956.1747bd86@tpl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081230055956.1747bd86@tpl>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2008 at 05:59:56AM -0700, Jonathan Corbet wrote:
> On Mon, 29 Dec 2008 16:27:32 +0100
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > I would prefer O_LOCK_FLAGS bit too. The global lock is not very nice
> > and I don't doubt someone will come up with a workload which
> > pounds on it.
> 
> Seems hard to imagine that it would be worse than the longstanding BKL
> situation.  That said, the global lock is clearly an unsubtle approach,
> and people don't like it.  I'd hoped to slip something quick through
> the merge window, but that seems unlikely, especially, since I'm
> allegedly on vacation.  I'll forget this patch for now and revisit it
> next week.

The global lock is an improvement over the current situation, so given
that we don't have any better counter-proposals we should put it in for
2.6.29.

