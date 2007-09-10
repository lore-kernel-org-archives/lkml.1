Return-Path: <linux-kernel-owner+w=401wt.eu-S965451AbXIJQGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965451AbXIJQGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 12:06:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965004AbXIJQFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 12:05:55 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:59070 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965001AbXIJQFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 12:05:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=PFwW3Fz5v4UJWksSB848W523BAhgBTWSQXB+hkiZRQjkn4XneX7F3Sr21qp/nGH+DvRCXn2Vw69ivFPkqGgI3u7ihOif4Vwx5RLqFljeWgfDAQvHmvCr9ZHxKw3KWjDWS9o4vFf8DVOzleam++6BdfhQe/1bc0Rl8zJJ6BfMCTo=
Message-ID: <6bc632150709100905y7c5c2camaa0044cf6fa09ea2@mail.gmail.com>
Date: Mon, 10 Sep 2007 21:35:52 +0530
From: "pradeep singh rautela" <rautelap@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [Q]Adding src files to 2.6.18 kernel and build failure query
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am facing some problem understanding and using the kernel Kbuild
system. I tried googling but not much of help.

Thanks to a good kbuild documentation in the tree. It looks like $(LD)
-r is not able to do what it is supposed to do. May be i am doing
something wrong?

here is a brief summary of what i am doing -

I added some .c files to a new dir under net/foo/ .
Added corresponding .h files to a new dir under include/foo/

Create a Kconfig and Makefile in net/foo/ directory.
Added corresponding entries to Makefile and Kconfig in the net/ dir.

I happily executed a make with a beaming face after selecting the foo
option after doing a
$make menuconfig.

To my surprise i got this error :-

make[1]: *** No rule to make target `arch/i386/kernel/vmlinux.lds',
needed by `__build'.  Stop

So , here is the question in short...

What do i need to change and where to make sure this thing vanishes
away and kernel compiles as usual like it always did earlier?

Any pointers?
PS:- I am not subscribed to the LKML,please CC me while replying to the list.

thanks
--pradeep

--
pradeep singh rautela

"question = ( to ) ? be : ! be;"
                -- Wm. Shakespeare
