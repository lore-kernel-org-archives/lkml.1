Return-Path: <linux-kernel-owner+w=401wt.eu-S1753551AbYJQJaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbYJQJaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 05:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbYJQJaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 05:30:07 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:24547 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbYJQJaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 05:30:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ojwkBhUFqp/2zpL88RaQmvZGAVZQJVeyCa5TonpDyLHl7wsgVkUU2990f/8hTzaGEW
         WwKfTNsvnMMi37+U2HVwHYEKPTgM7Re9Ny25AOfXqqdzz4zbnKpL08WppFFbiMhgCxQE
         Y9Na8CYE8anWa2qeGg1tLbOqTSABvOGrSDSO4=
Message-ID: <19f34abd0810170230s755aa0e4vea38c26e093e173c@mail.gmail.com>
Date: Fri, 17 Oct 2008 11:30:04 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for October 17
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "Eric Van Hensbergen" <ericvh@gmail.com>,
       "Ron Minnich" <rminnich@sandia.gov>,
       "Latchesar Ionkov" <lucho@ionkov.net>
In-Reply-To: <20081017194045.202e6271.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081017194045.202e6271.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 10:40 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Today's tree will not build for powerpc allyesconfig (libc aborts the
> link due to a free() problem), sparc(32) defconfig and probably some
> other configurations.

Hi, I ran into this with slightly modified fedora config:

  CC      net/9p/protocol.o
net/9p/protocol.c: In function 'p9pdu_finalize':
net/9p/protocol.c:545: error: 'p9_debug_level' undeclared (first use
in this function)
net/9p/protocol.c:545: error: (Each undeclared identifier is reported only once
net/9p/protocol.c:545: error: for each function it appears in.)
net/9p/protocol.c:545: error: 'P9_DEBUG_PKT' undeclared (first use in
this function)
make[2]: *** [net/9p/protocol.o] Error 1
make[1]: *** [net/9p] Error 2
make: *** [net] Error 2

...and couldn't find it in the automatic build test results either. 9P
maintainers Cced.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
