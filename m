Return-Path: <linux-kernel-owner+w=401wt.eu-S1764195AbYJJUmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764195AbYJJUmf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 16:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761963AbYJJUmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 16:42:08 -0400
Received: from blaine.gmane.org ([80.91.229.8]:54193 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761761AbYJJUmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 16:42:07 -0400
Message-ID: <48EFBE00.8030609@tmr.com>
Date: Fri, 10 Oct 2008 16:41:36 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.17) Gecko/20080925 Fedora/1.1.12-1.fc9 SeaMonkey/1.1.12
MIME-Version: 1.0
To: Yudha Harimantoro T 
	<public-yudha.ht-Re5JQEeQqe8AvxtiuMwx3w@hugh.gmane.org>
CC: public-kernel-testers-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org,
       public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org
Subject: Re: Error : Linux-2.6.27
References: <264b990a0810100126l1029f734x7204f8c42ae21609@mail.gmail.com>
In-Reply-To: <264b990a0810100126l1029f734x7204f8c42ae21609@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Yudha Harimantoro T wrote:
> Hi all,
> 
> Yesterday I build kernel 2.6.26.6 and it's run well. Today I got
> 2.6.27 patch and try to build it.
> 
> I build with `make oldconfig` and answer any question with default
> answer, I just press [enter].
> I build with `make`. No error and all compiled.
> Then I install with `make modules_install` and `make install`.
> 
I realize that this is a low-probability thought, but did you:
- apply the patch against 2.6.26 NOT 2.6.26.6
- run make clean before applying the patch

> After reboot the system I got 'kernel panic'.
> This is the error picture :
> http://www.ryht.co.cc/wordpress/wp-content/uploads/2008/10/pa101358.jpg
> Is it a bugs?
> 
> http://www.ryht.co.cc/wordpress/wp-content/uploads/2008/10/pa101353.jpg
> [2.6.26.6 run well]
> 
I keep configs in a separate place. I would first copy a 2.6.26 tree to a new 
directory (cp -rl linux-2.6.26 linux2.6.27) then be sure I had a clean copy with 
"make distclean" (or "make mrproper") and then apply the 2.6.27 patch. Then I 
would copy the 2.6.26 (or maybe 2.6.26.6) config to .config, and make the oldconfig.

None of that is magic, it just keeps me from making common mistakes, lets me 
start with a clean 2.6.27, etc, etc.

You mentioned oldconfig, but not starting back with a clean 2.6.26, which made 
me think of this.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

