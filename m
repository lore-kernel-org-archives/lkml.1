Return-Path: <linux-kernel-owner+w=401wt.eu-S1757866AbYJQSt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866AbYJQSt7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 14:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757856AbYJQStG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 14:49:06 -0400
Received: from kroah.org ([198.145.64.141]:38543 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755583AbYJQSst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 14:48:49 -0400
Date: Fri, 17 Oct 2008 10:46:57 -0700
From: Greg KH <greg@kroah.com>
To: Steven Noonan <steven@uplinklabs.net>
Cc: Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Message-ID: <20081017174657.GH2221@kroah.com>
References: <20081016002509.GA25868@kroah.com> <20081016124943.GE23630@cs181140183.pp.htv.fi> <20081016151748.GA31075@kroah.com> <20081016164602.GA22554@cs181140183.pp.htv.fi> <20081017034717.GA28188@kroah.com> <20081017064751.GE22554@cs181140183.pp.htv.fi> <20081017075544.GB4850@kroah.com> <f488382f0810170116qd7e1845h8942c195352934d1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f488382f0810170116qd7e1845h8942c195352934d1@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 01:16:38AM -0700, Steven Noonan wrote:
> I believe some of Adrian's concerns are valid. Userspace programs will
> indeed break, largely because some depend on build-time and run-time
> checks for the kernel version being >=2.6.0 or >=2.4.0 and so forth. I
> suspect the best way to prove userspace breakage would be to make a
> branch of the kernel with a new versioning scheme (8.10, 2008.10,
> whatever) and use that as the installed kernel while building a Gentoo
> system. I suspect you'd see massive breakage.

That would be trivial for me to test, IFF we want to do something like
this.

But again, that's a technical thing, that can be solved _IFF_ we want to
change things.

And that's my point here, do we want to change the current numbering
scheme as people have expressed annoyances of the current one.

thanks,

greg k-h
