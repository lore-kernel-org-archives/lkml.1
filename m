Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbZGCVyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbZGCVyI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 17:54:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbZGCVx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 17:53:57 -0400
Received: from mail-vw0-f202.google.com ([209.85.212.202]:61710 "EHLO
	mail-vw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbZGCVx4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 17:53:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jDfHDtKww4kTAV3U27gC+QpieBdcdvmRbE9RAoY2LhrqYd1wEXPvS5eAvzjmXekzef
         lCDUApHUfmHWAqwhArsLadsxYxg8N990jTnyfyoBWa1GAOxZ/8i5VrBXO6FdPlA8jiJT
         /5iCrnlk3UQR3Y+A6O3sRQZj570Z3lNf1y/fU=
MIME-Version: 1.0
In-Reply-To: <20090703214309.GA15265@uranus.ravnborg.org>
References: <20090703214309.GA15265@uranus.ravnborg.org>
Date: Fri, 3 Jul 2009 23:53:58 +0200
Message-ID: <56e1b5710907031453i75066006p8a72c19a65d28efe@mail.gmail.com>
Subject: Re: [GIT] kbuild fixes
From: Floris Kraak <randakar@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, WANG Cong <amwang@redhat.com>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Frans Pop <elendil@planet.nl>,
       maximilian attems <max@stro.at>, Tim Abbott <tabbott@ksplice.com>,
       Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 3, 2009 at 11:43 PM, Sam Ravnborg<sam@ravnborg.org> wrote:
>
> - disabling of -Wformat-security
>  We looked at it and 'fixing' the warnings was not pleasant

The alternative is roughly 136 'trivial' patches to shut them all up*
and one to turn this flag on unconditionally to prevent hackers from
adding more of them after that ;-)

The alternative to *that* is improving on this silly flag:
- Either finding some way to teach GCC how to not emit warnings about
usage that is entirely sane.
- Or finding some way to teach some other build tool to catch unsafe
usage without polluting the build with false positives.

Take your pick.

*) While I can't give you 100% certainty about every warning I know
for a fact the vast majority of the warnings at least consists of
false positives so there'd be no other benefit from them except a
quieter kernel build on certain distro's ;-)

Regards,
Floris
---
'Or lawyers may say, “But if I decline, someone else will do it. So
what is gained?” My reply: “Let someone else do it. But not you. Honor
is personal. Worry about yourself.  You don’t get a pass from moral
responsibility because you acted for a client.”

That’s the first lesson I would offer, aimed at lawyers. A second
lesson, aimed at all, is this: Keep ready your capacity for outrage.
This is very important. Next to the vote, outrage is the one response
each of us can contribute. Outrage is how honor must confront
dishonor. If we lose the capacity for outrage, we are in serious
trouble. '
   --- Stephen Gillers
