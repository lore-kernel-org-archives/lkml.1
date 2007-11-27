Return-Path: <linux-kernel-owner+w=401wt.eu-S1755801AbXK0AsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801AbXK0AsO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 19:48:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753238AbXK0Ar7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 19:47:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188AbXK0Ar6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 19:47:58 -0500
Message-ID: <474B6810.6070703@redhat.com>
Date: Mon, 26 Nov 2007 16:42:56 -0800
From: Ulrich Drepper <drepper@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCHv4 5/6] Allow setting O_NONBLOCK flag for new sockets
References: <200711200653.lAK6rE6B025891@devserv.devel.redhat.com> <20071119.235944.82120402.davem@davemloft.net> <474305A5.7070100@redhat.com> <474323CA.9030306@zytor.com> <alpine.LFD.0.9999.0711261003290.5869@woody.linux-foundation.org> <474B1C6D.6080405@zytor.com> <474B55F5.1050706@redhat.com> <474B6179.4040508@zytor.com>
In-Reply-To: <474B6179.4040508@zytor.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

H. Peter Anvin wrote:
> No.
> 
> I already said I'm not looking at changing the calling convention for
> existing syscalls.

I did not suggest or ask for that at all.

I was asking you to consider the real implementation details for a new
syscall mechanism.

We do not want to abandon the use of syscall/sysenter and go back to int
(on x86/x86-64).  This means that you have to come up with a mechanism
which hooks into the current syscall/sysenter path while preserving full
backward compatibility.

Now it's your turn.  How do you do this without additional costs?


> Hardly so, as evidenced by the fact that we have successfully done so
> for 15 years already; a number of Linux architectures require this
> information for the existing system calls.

Nothing at this scale is there in the moment, as far as I can see.  And
nothing so critical for getting right.

Talk is cheap.  You still haven't shown one bit if design how you want
to achieve your grand goal.  The time for hand-waiving is over.  Do some
work or step out of the way.  Nothing you have said so far in the least
convinces me and your arguments like "sys_indirect adds parameters" are
not really contested.  Yes, that's what sys_indirect does.  So what?  It
does this with almost no cost which outweighs the ugliness factor in my
book.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFHS2gQ2ijCOnn/RHQRAlN5AKCWZQL97sROWBv33//Uj/MN+CNi3gCdFgCU
uLVEOfclERpakp1kdYzy2oI=
=stVB
-----END PGP SIGNATURE-----
