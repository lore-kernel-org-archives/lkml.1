Return-Path: <linux-kernel-owner+w=401wt.eu-S1756871AbZB0B2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbZB0B2H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 20:28:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbZB0B1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 20:27:54 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45914 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbZB0B1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 20:27:53 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [TOMOYO #15 0/8] TOMOYO Linux
Cc: kosaki.motohiro@jp.fujitsu.com, Toshiharu Harada <haradats@nttdata.co.jp>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, jmorris@namei.org,
       takedakn@nttdata.co.jp, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20090225194615.GE2645@elf.ucw.cz>
References: <49A2521E.5030805@nttdata.co.jp> <20090225194615.GE2645@elf.ucw.cz>
Message-Id: <20090227100350.1515.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Fri, 27 Feb 2009 10:27:47 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

> >>>>>> TOMOYO Linux is a name-based MAC extension (LSM module) for the Linux kernel.
> >>>>>>
> >>>>> Applied to  
> >>>>> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next
> >>>>>
> >>>> Does that mean tomoyo is scheduled for 2.6.30?
> >>>>
> >>> TOMOYO is already in linux-next tree and ready to go into 2.6.30 .
> >>
> >> Last time I looked it included script parser and some
> >> interpretter... Was that solved?
> 
> >
> > Are you talking about the interface between
> > userland and kernel regarding string data?
> 
> Yes. maybe ioctl() is worse, but I don't think c-like language parser
> in kernel is acceptable.

for just clarification to me.

IIUC, many developers said UNNECESSARY parser is BAD (yes, I also think so),
but nobody said any parser is bad.

Therefore, I think point is that the patch have enough reasonable reason or not.
and, I thought "pavel, good job. you're right" at you oppositing time because
tomoyo did't explain any reason at that time.

However, they changed. the patch description of the "[TOMOYO #15 3/8] Common functions for TOMOYO Linux."
explain the reason.
for me, I feel it's reasonable reason. then I didn't oppose current tomoyo posting.

So, I don't understand which you oppose
   (1) ANY parser is bad.
   (2) current description still don't explain enough reason.

May I ask you?



