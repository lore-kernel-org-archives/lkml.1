Return-Path: <linux-kernel-owner+w=401wt.eu-S1757016AbYBJLc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016AbYBJLc7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 06:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755667AbYBJLcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 06:32:51 -0500
Received: from twin.jikos.cz ([213.151.79.26]:48679 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755620AbYBJLcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 06:32:50 -0500
Date: Sun, 10 Feb 2008 13:30:15 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Amit Shah <amitshah@gmx.net>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Sergey Vlasov <vsu@altlinux.ru>
Subject: Re: [git pull] x86 arch updates for v2.6.25
In-Reply-To: <f77718aa0802090611n240bfa5avbbe2abeb53607f48@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802101326270.7699@twin.jikos.cz>
References: <20080130011550.GA31853@elte.hu>
 <f77718aa0802090611n240bfa5avbbe2abeb53607f48@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Feb 2008, Amit Shah wrote:

> cc503c1b "x86: PIE executable randomization" doesn't boot on my Ubuntu
> Feisty Fawn Intel Core2 system.
> I get numerous segfaults before getting a (initramfs) busybox shell. A
> similar bug was reported much earlier:

[ please, when you experience a problem and are able to identify the 
commit that triggers it, don't forget to CC the author of the commit in 
question -- me, in this case ]

As far as I remembers, Ubuntu uses klibc in initramfs, right?

What version of klibc do you have? There was a bug in klibc that causes 
such behavior on PIE-randomization-enabled kernels, and has been fixed in 
klibc-1.45 by commit [1]. Please make sure you have updated klibc version 
that doesn't contain this bug.

[1] http://git.kernel.org/?p=libs/klibc/klibc.git;a=commit;h=10df6dfb13ffefe716f12136bbc667f18ff64744

-- 
Jiri Kosina
