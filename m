Return-Path: <linux-kernel-owner+w=401wt.eu-S1752313AbZKHOpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbZKHOpq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 09:45:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbZKHOpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 09:45:46 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:49167 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbZKHOpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 09:45:45 -0500
Date: Sun, 8 Nov 2009 15:45:50 +0100
From: Andreas Mohr <andi@lisas.de>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Michael A. Griffith" <grif@acm.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Please get this committed, _NOW_ (preferrably 5 years
	ago), thanks.
Message-ID: <20091108144548.GA13429@rhlx01.hs-esslingen.de>
References: <20091108120008.GA21611@rhlx01.hs-esslingen.de> <20091108142506.GA6240@hack>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091108142506.GA6240@hack>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Nov 08, 2009 at 10:25:06PM +0800, Américo Wang wrote:
> On Sun, Nov 08, 2009 at 01:00:08PM +0100, Andreas Mohr wrote:
> >--- linux-2.6.32-rc6/init/main.c.orig	2009-11-08 11:09:51.000000000 +0100
> >+++ linux-2.6.32-rc6/init/main.c	2009-11-08 12:40:11.000000000 +0100
> >@@ -846,7 +846,47 @@ static noinline int init_post(void)
> > 	run_init_process("/bin/init");
> > 	run_init_process("/bin/sh");
> > 
> >-	panic("No init found.  Try passing init= option to kernel.");
> >+	panic("No init found.  Try passing init= option to kernel. "
> >+    y          "See Linux " __FILE__ " for guidance.");
> 
> 
> I would like to put those guidelines in a doc file, instead
> of being a FAT comment in the source code.

Heh, somehow I fully expected this objection to come up ;)
(and you're probably right after all)

So, where to put it?
Documentation/initrd.txt is related, however I'd create something
like Documentation/initialization/...
Or perhaps Documentation/bootup/init.txt ?

> And, you're explaining the _user space_ reasons that causes
> this problem, not related with kernel at all.

That's usually within the responsibility of the one passing control,
not the one gaining control.
Just like with children, where it's firmly the parents' job to take care
of getting their children safely to kindergarden, not the kindergarden's ;)

Plus in my case it _was_ a kernel issue (problematic/non-working serial
console device). And except for the linker issues of missing libraries,
many issues (USB functionality etc.) were kernel-related, too.

Thanks,

Andreas Mohr
