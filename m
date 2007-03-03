Return-Path: <linux-kernel-owner+w=401wt.eu-S2992886AbXCCBlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992886AbXCCBlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 20:41:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992892AbXCCBlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 20:41:16 -0500
Received: from smtp.osdl.org ([65.172.181.24]:51109 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992886AbXCCBlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 20:41:15 -0500
Date: Fri, 2 Mar 2007 17:41:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc2-mm1
Message-Id: <20070302174110.5740b09e.akpm@linux-foundation.org>
In-Reply-To: <45E8CDF3.7010406@googlemail.com>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
	<6bffcb0e0703021542k4f882531r21807c7efdbd0ebc@mail.gmail.com>
	<20070302164009.a2aa6cbc.akpm@linux-foundation.org>
	<45E8CDF3.7010406@googlemail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 03 Mar 2007 02:22:59 +0100
Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> Andrew Morton napisa__(a):
> > On Sat, 3 Mar 2007 00:42:33 +0100
> > "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com> wrote:
> > 
> >> On 02/03/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> >>> Temporarily at
> >>>
> >>>   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm1/
> >>>
> >> I have noticed some strange system behavior. When i try to build a
> >> kernel (medium load) - X, keyboard, mouse and sound hangs.
> >>
> >> I can ping machine and I can use magic SysRq key, but that's all.
> >>
> >> 2.6.20-mm2 was fine, 2.6.21-rc2 works well (over 800 patches since
> >> 2.6.20-mm2 - great...)
> >>
> >> NIL (Nothing Interesting in Logs)
> >>
> > 
> > Can we see the sysrq-T output please?
> > 
> 
> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc2-mm1/sys.log
> 

Well that's all very dull - everything's just sitting there asleep.

If it was just X then I'd suspect the psmouse changes (are you PS2 or USB?)

Or I'd suspect that the entire interrupt system has gone bust, but you're
still able to do sysrq.

How are you doing sysrq, btw?   Serial console?  alt-F7 into a vgaconsole?

Are you able to log in from another machine via ssh?

Are you able to log into it via ssh before it hangs and run things like
`top' and `watch -n1 cat /proc/interrupts', see what they do when it hangs?

Is the CPU idle when it hangs, or is it busy?  If busy, what does sysrq-P
say?

