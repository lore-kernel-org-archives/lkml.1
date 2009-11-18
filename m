Return-Path: <linux-kernel-owner+w=401wt.eu-S932353AbZKRUK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353AbZKRUK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 15:10:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932248AbZKRUK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 15:10:58 -0500
Received: from gv-out-0910.google.com ([216.239.58.190]:44440 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152AbZKRUK5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 15:10:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=KTVQAXXVoWxmsPFV52bfuPnV7T8giuMbtmea418PS4S+d88rOW41KLZAEprqssq8F4
         l2zbUEaEjxU411wI02mIyL7RMsZSFquk6OVP7+zyqVAV1e2v2sFq+w03AMgT8rqsADvH
         E6KXtkjqFULebBrnSQ7/FZUKGIyOZyfNhWP38=
MIME-Version: 1.0
Date: Wed, 18 Nov 2009 21:11:01 +0100
Message-ID: <78b8ce680911181211k6c15a976u52186b5849224040@mail.gmail.com>
Subject: LinSched updated to current linux kernel version
From: Jon Tore Hafstad <jontore@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, dhaval.giani@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, bbb@cs.unc.edu, henrik@austad.us, jmc@cs.unc.edu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Hi all

I wish to inform you about an update of LinSched (The Linux Scheduler
Simulator([1])) I'm currently working on.

I'm a master's student at NTNU (Norwegian University of Technology and
Science) and writing my project thesis on real-time schedulers. As a
part of this project I've been working on updating LinSched  to the
current version of the linux kernel (2.6.32).

== Motivation ==
I wished to implement different EDF schedulers to gain a better
understanding of kernel internals as well as scheduling dynamics. I
got some feedback from Henrik Austad  that LinSched was a tool that
made implementing a scheduler in to  the linux kernel easier,  since
the code compiles in a fraction of the time the kernel does (Yes, I
know you can pull all sorts of tricks and tweaks in order to speed up
a kernel compilation), a segfault will be a segfault, and not a kernel
oops ;),and the full range of debuggers and memory analyzers will be
available.

The reason for sending this email to you now, is that even though
there still are several unresolved issues, the code is in a
more-or-less stable state and I'd like to let others have a look at it
too.

== Work ==
Thanks to thep way to the orgininal version was made by John M.
Calandrino[1], Dan P. Baumberger, Tong Li [2], Jessica C. Young, and
Scott Hahn. I got a good start and understanding of what would be
necessary to update, to get LinSched runnig with the current linux
kernel.

The main philosophy in LinSched is to keep things as close to the
kernel as possible. Enabling an easier transition from testing
scheduler in LinSched to actually getting it running in the kernel.
Most of the major challenges I have met, has been all the new features
added in the kernel since 2.6.32 such as:
Load balancing for RT tasks.
Group scheduling.

== Remaining Work ==
One of the major issues right now is the hrtimers, which large
portions of the scheduler now use. I have not decided exactly how to
solve this issue yet,but this will be the focus of my work for the
coming weeks.

--
[1]  http://www.cs.unc.edu/~jmc/linsched/
[2] http://happyli.org/tongli/

Regards,

Jon Tore Hafstad

Code can be found at: http://austad.us/jontore/
