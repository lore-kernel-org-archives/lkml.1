Return-Path: <linux-kernel-owner+w=401wt.eu-S1754200AbZKHPLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbZKHPLR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 10:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909AbZKHPLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 10:11:17 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:40770 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662AbZKHPLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 10:11:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=gnVsqXV7PveeoZxmxsELCCJ752jlEVlmKZeu/A7KeWl4J8S0vtxFwDQ8siSXCxYtpt
         cEb+JLt7RPSqRKrrzo1xEuxk2GwNoviuAbGMu3KsODh3XmVNxXXp2gothmJze3qfB9qt
         Ro0FZ99rrMmQ7mfgPkQscFM1GK67GEk01Mj9s=
Date: Sun, 8 Nov 2009 23:11:53 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Andreas Mohr <andi@lisas.de>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Michael A. Griffith" <grif@acm.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Please get this committed, _NOW_ (preferrably 5 years
	ago), thanks.
Message-ID: <20091108151153.GC6240@hack>
References: <20091108120008.GA21611@rhlx01.hs-esslingen.de> <20091108142506.GA6240@hack> <20091108144548.GA13429@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091108144548.GA13429@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 08, 2009 at 03:45:50PM +0100, Andreas Mohr wrote:
>Hi,
>
>On Sun, Nov 08, 2009 at 10:25:06PM +0800, Américo Wang wrote:
>> On Sun, Nov 08, 2009 at 01:00:08PM +0100, Andreas Mohr wrote:
>> >--- linux-2.6.32-rc6/init/main.c.orig	2009-11-08 11:09:51.000000000 +0100
>> >+++ linux-2.6.32-rc6/init/main.c	2009-11-08 12:40:11.000000000 +0100
>> >@@ -846,7 +846,47 @@ static noinline int init_post(void)
>> > 	run_init_process("/bin/init");
>> > 	run_init_process("/bin/sh");
>> > 
>> >-	panic("No init found.  Try passing init= option to kernel.");
>> >+	panic("No init found.  Try passing init= option to kernel. "
>> >+    y          "See Linux " __FILE__ " for guidance.");
>> 
>> 
>> I would like to put those guidelines in a doc file, instead
>> of being a FAT comment in the source code.
>
>Heh, somehow I fully expected this objection to come up ;)
>(and you're probably right after all)
>
>So, where to put it?
>Documentation/initrd.txt is related, however I'd create something
>like Documentation/initialization/...
>Or perhaps Documentation/bootup/init.txt ?

Personally, I prefer Documentation/init.txt, but adding it to
initrd.txt also makes sense for me. :)

>
>> And, you're explaining the _user space_ reasons that causes
>> this problem, not related with kernel at all.
>
>That's usually within the responsibility of the one passing control,
>not the one gaining control.
>Just like with children, where it's firmly the parents' job to take care
>of getting their children safely to kindergarden, not the kindergarden's ;)
>
>Plus in my case it _was_ a kernel issue (problematic/non-working serial
>console device). And except for the linker issues of missing libraries,
>many issues (USB functionality etc.) were kernel-related, too.

Yeah, I mentioned it to mean it is not suitable to explain
user-space problems in a kernel source file. Putting it into a kernel
doc should be fine.

Thanks.


-- 
Live like a child, think like the god.
 
