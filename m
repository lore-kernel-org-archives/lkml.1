Return-Path: <linux-kernel-owner+w=401wt.eu-S933332AbXCMU4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933332AbXCMU4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 16:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933333AbXCMU4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 16:56:31 -0400
Received: from colin.muc.de ([193.149.48.1]:4414 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933332AbXCMU4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 16:56:30 -0400
Date: 13 Mar 2007 21:56:28 +0100
Date: Tue, 13 Mar 2007 21:56:28 +0100
From: Andi Kleen <ak@muc.de>
To: Rik van Riel <riel@redhat.com>
Cc: Chris Wright <chrisw@sous-sol.org>, Andrew Morton <akpm@osdl.org>,
       Daniel Walker <dwalker@mvista.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH 2/9] Sched clock paravirt op fix.patch
Message-ID: <20070313205628.GB46469@muc.de>
References: <200703020254.l222sOaM009656@zach-dev.vmware.com> <20070313140129.GB92373@muc.de> <45F6C2A3.4040305@goop.org> <20070313160709.GH10574@sequoia.sous-sol.org> <20070313161656.GA12128@muc.de> <45F6D361.8080106@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F6D361.8080106@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 12:37:53PM -0400, Rik van Riel wrote:
> Andi Kleen wrote:
> >On Tue, Mar 13, 2007 at 09:07:09AM -0700, Chris Wright wrote:
> >>* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> >>>In other words, regardless of whether this particular pv_op lives or
> >>>dies, we're going to need to have to deal with stolen time properly.  I
> >>>think this hook is reasonable and useful step towards doing that.
> >>Exactly.  Normal interrupts we can handle.  Having CPU completely
> >>disappear for unkown time periods we can't, and will need to.
> >
> >But that is just what a interrupt is.
> 
> Interrupts tend to be reasonably short though.

It depends -- under heavy network load you can spend a long time
just processing interrupts.

-Andi

