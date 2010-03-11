Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928Ab0CKPBN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 10:01:13 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:60620 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932522Ab0CKPBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 10:01:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jZRvE5TQHRuSsRWlRBp4mFGLIbbIJfdJE6ItLkniM/2Ukb11+VUFPyEoJJl3FIgo0q
         8MAc3U9JAoypvYExE0SHVbjxHGG9myGeToV2NN0ynqxcPETs5IQ81YbCbeY+Qsam3YbY
         5+Qvm7NEj7dS8rDiUXcIZL5C+N1LBi+ILoC+c=
Subject: Re: [PATCH 0/7] tcp: bugs and cleanup for 2.6.34-rc1
From: Eric Dumazet <eric.dumazet@gmail.com>
To: William Allen Simpson <william.allen.simpson@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>
In-Reply-To: <4B98D592.6040301@gmail.com>
References: <4B98D592.6040301@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Mar 2010 16:01:04 +0100
Message-ID: <1268319664.2986.535.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 11 mars 2010 à 06:35 -0500, William Allen Simpson a écrit :
> I'd have thought that there would be greater interest about patching
> crashing bugs, signed versus unsigned (underflow) bugs, TCP DoS bugs,
> TCP data corruption, and TCP performance problems....
> 
> There's been ample warning.  Zero-day security issues will be reported
> to the usual announcement lists.  In particular, these 0day exploits
> affect systems as far back as the 2005 changeover to git.
> 
> Combination of patches reported in October, November, December, January,
> and February, for 2.6.32, 2.6.33, and now 2.6.34.
> 
> This code has had previous review and several months of limited testing.
> 
> Some portions were removed during the various TCPCT part 1 patch splits,
> then were cut off by the sudden unexpected end of that merge window.
> [03 Dec 2009]  I've restarted the sub-numbering (again).
> 
> Of particular interest are the TCPCT header extensions that already
> appear in the next phase of testing with other platforms.  These patches
> allow correct reception without data corruption.
> 
> The remainder of the original TCPCT part 2 will be merged with part 3.
> 
> [Updated to 2010 Mar 08 2.6.34-rc1.]
> --

Mr William Allen Simpson

It would be nice if you could update your knowledge of how linux
development works these days.

Please spend few hours for that, it will save us lot of time.
Our time is valuable as much as yours, I doubt we'll change our habits
to fit your wills.

You throw too many changes at once to let them being reviewed,
understood, and accepted.

For your information, we had to correct a fatal bug introduced by your
last commits, and as far as I know, you didnt help that much.

http://git2.kernel.org/?p=linux/kernel/git/davem/net-2.6.git;a=commit;h=28b2774a0d5852236dab77a4147b8b88548110f1

<at this moment of time>

We are post linux-2.6.34-rc1, so only bug fixes are wanted by Linus and
David, to be integrated in 2.6.34 (and previous versions if needed)

We are _not_ interested by new stuff at *this* moment, especially if it
takes lot of time to review.

</at this moment of time>

New network stuff (for 2.6.35 or 2.6.36) should be validated once
net-next-2.6 re-opens (in about one week I suppose, David will send a
mail to netdev to let us/you know the exact moment).

So please split your patches again and submit only bug fixes to netdev.

Once accepted by community and maintainer, David will push them
upstream.

Then, in about 10 days, please submit new stuff that hopefully find
their way if you accept our reviews and comments.

Last time I made some comments on your patches, you just ignored them or
loaned, because obviously who is Eric Dumazet to tell William Allen
Simpson how things should be done ? Silly me !

I remember this fairly well, this is why I ignored your last submissions
(and privately explained to you why I did this).

Speaking for myself, but as your previous mails were ignored, I felt it
was time to clarify the points.



