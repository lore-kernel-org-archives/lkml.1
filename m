Return-Path: <linux-kernel-owner+w=401wt.eu-S1758696AbYHHSW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696AbYHHSW4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 14:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbYHHSWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 14:22:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47987 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbYHHSWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 14:22:47 -0400
To: "john maclean" <jayeola@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Thinkpad ACPI woes
From: Andi Kleen <andi@firstfloor.org>
References: <4170c1720808080448qb94d5beua26a67c89f14a5ce@mail.gmail.com>
Date: Fri, 08 Aug 2008 20:22:43 +0200
In-Reply-To: <4170c1720808080448qb94d5beua26a67c89f14a5ce@mail.gmail.com> (john maclean's message of "Fri, 8 Aug 2008 12:48:00 +0100")
Message-ID: <87abfn4b9o.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"john maclean" <jayeola@gmail.com> writes:

> I'm a user and lurking on this list to keep abreast of what you chaps
> are upto. Great work and keep it up. However ACPI used to just work on
> my IBM Thinkpad x30. I close the lid, open it after some time and I
> get X back. Right now it's unpredictable as I never can tell when I'll
> get it out of sleep as the screen remains black no matter what keys i
> hit. This is with no boot parameters and default "everything" from
> distribution maintainers. This is the case ever since the 2.6.25.+
> kernel.
>
> Right now uname -r 2.6.25.10-libre.86.fc9.1.i686.

The usual formal procedure for handling hard "i have no clue what causes it"
regression problem is:

- You make sure you can reproduce the problem reliably
- You verify the variable is really only the kernel and not some
user space update. You can do that by only changing kernels
and verifying the bug was not there with the old kernel, is there again 
with the new kernel (2 reboots)  
- You check it also happens with mainline kernels, not only fedora
- Then you do a git bisect between these two kernel versions. You'll
need to be able to fetch git versions of the kernel and compile
them yourself. Then do man git-bisect and do the bisecting.
[There are various better tutorials on that available if you google for it]
- Then you identify some commit that causes the problem.
- You report that to the author (all people in From/Signed-off-by) and
to linux-kernel.

It's not totally trivial, but also not that difficult, and while
it takes some time it really gives results.

-Andi
