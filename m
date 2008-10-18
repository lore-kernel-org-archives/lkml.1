Return-Path: <linux-kernel-owner+w=401wt.eu-S1755496AbYJRBUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbYJRBUS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 21:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbYJRBUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 21:20:06 -0400
Received: from mail.lang.hm ([64.81.33.126]:42801 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbYJRBUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 21:20:05 -0400
Date: Fri, 17 Oct 2008 18:20:35 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Steven Noonan <steven@uplinklabs.net>
cc: Greg KH <greg@kroah.com>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
In-Reply-To: <f488382f0810170116qd7e1845h8942c195352934d1@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0810171815220.11079@asgard.lang.hm>
References: <20081016002509.GA25868@kroah.com>  <20081016124943.GE23630@cs181140183.pp.htv.fi>  <20081016151748.GA31075@kroah.com>  <20081016164602.GA22554@cs181140183.pp.htv.fi>  <20081017034717.GA28188@kroah.com>  <20081017064751.GE22554@cs181140183.pp.htv.fi>
  <20081017075544.GB4850@kroah.com> <f488382f0810170116qd7e1845h8942c195352934d1@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Oct 2008, Steven Noonan wrote:
> I believe some of Adrian's concerns are valid. Userspace programs will
> indeed break, largely because some depend on build-time and run-time
> checks for the kernel version being >=2.6.0 or >=2.4.0 and so forth.

things that do this sort of check would work just find with version 8.10.0 
or 2008.10.0

the ones that would fail would be ones that made assumptions about the 
number (it can only have X digits in this position, I don't need to check 
the '2', only the '4' vs '6', etc). anything that does this sort of thing 
is broken already, and will fail at some point in the future, even without 
a radical numbering change.

> I
> suspect the best way to prove userspace breakage would be to make a
> branch of the kernel with a new versioning scheme (8.10, 2008.10,
> whatever) and use that as the installed kernel while building a Gentoo
> system. I suspect you'd see massive breakage.

I suspect that you won't see anything noticable. you don't need to make a 
branch of the kernel, just edit the kernel source to change the version.

> I think a version numbering system change would be OK (though I
> wouldn't very much -like- it), so long as there was a way for
> userspace software to be able to differentiate between a kernel with
> the old versioning system and the new versioning system.

one nice thing about the year-based numbering (be it 8.x or 2008.x) is 
that all the numbers in the new numbering scheme are > any numbers in the 
old numbering scheme. so all you need to do is to check for > whatever 
version added the feature you need.

> I think perhaps a better option in the long run is to start a v2.7
> tree and figure out some Cool New Stuff(tm) to implement, keeping
> consistency with the current versioning scheme.

Red Herring, the Cool New Stuff is happening now, no 2.7 needed.

David Lang
