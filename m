Return-Path: <linux-kernel-owner+w=401wt.eu-S1763087AbYEGUAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763087AbYEGUAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 16:00:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753992AbYEGT7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 15:59:52 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:55207 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760766AbYEGT7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 15:59:49 -0400
Date: Wed, 7 May 2008 22:58:30 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       kernelnewbies@nl.linux.org, kernel-janitors@vger.kernel.org
Subject: kernel-testers - finding regressions in the kernel
Message-ID: <20080507195830.GC32750@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Please send further questions only on the kernel-testers list. ]

One big problem we face in kernel development are regressions - a kernel 
that worked for the user and a more recent kernel no longer works for 
the user.

Another problem is for newbies to get into kernel development.
There aren't many useful coding tasks for newbies available.

Testing the kernel and learning how to debug problems both brings 
immediate value to the kernel and can be a good way to get started
with kernel development.


Regressions are bad since they make it harder for users to upgrade the 
kernel. They cause problems for people when upgrading the kernel and 
result in many people running old kernels with known security holes.

There are easy to find regressions like compile errors, but the real 
problems are things like for example:
- system doesn't boot
- system crashes with a specific workload
- mp3 playback now stutters when copying files in the background
- when doing this or that the system feels worse

Automated tests can find some of these problems, but many of the 
problems that affect only some specific hardware or the interactive 
feeling of the computer can not be found automatically.

And a helpful property of regressions is that for a reproducible 
regression it's relatively easy to figure out what broke it through 
bisection.

There are usually two months between some kernel developer adding a new 
regression to the kernel and the regression reaching a stable kernel, 
and it's important to catch as many of them as early as possible.

The next step will be to also test -next and -mm kernels for identifying 
regressions even before they reach Linus' tree.



Mailing list:
http://vger.kernel.org/vger-lists.html#kernel-testers

The list is primarily for people starting at testing kernels, but if 
people with experiences in kernel testing and/or kernel debugging want 
to join that's highly appreciated.


Webpage:
http://kernelnewbies.org/KernelTesters


FAQ:


Q:
What will be discussed on the mailing list?

A:
- which kernels to test
- how to test them
- how to turn observed problems into proper bugreports


Q:
What are the prerequisites for participating?

A:
You should already know how to build and install your own kernel
(http://www.kroah.com/lkn/ is a good introduction).

And be willing to spend quite some time with debugging problems
you discover.


Q:
How to start?

A:
Run 2.6.25 for a week.
If you already did this, check what the latest snapshot listed at
http://www.kernel.org/ is and try this kernel.


Q:
The snapshot worked just fine for some days.

A:
The kernel was less broken than expected. :-)
(Well, this actually should be the normal case...)

Try a more recent snapshot and follow the discussions on the mailing 
list what to test next.


Q:
Is it dangerous to test such kernels?

A:
Most of the times there are no problems.

But your system might crash, and in the worst case it might turn the 
contents of your disks into garbage.

But you anyway have a backup, don't you?

If you need your system to work for reaching some deadline in real life 
you obviously shouldn't test any kernels.


Q:
I found a regression!

A:
Great!

Please tell the details on the mailing list.


Q:
What about bugs that are not regressions?

A:
Such bugs can also be discussed, but they are not the primary target.

