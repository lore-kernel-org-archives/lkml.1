Return-Path: <linux-kernel-owner+w=401wt.eu-S1756921AbXKWVBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbXKWVBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 16:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753357AbXKWVBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 16:01:10 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:59597 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbXKWVBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 16:01:09 -0500
X-AuthUser: davidel@xmailserver.org
Date: Fri, 23 Nov 2007 13:01:03 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Where is the new timerfd?
In-Reply-To: <a36005b50711231038j48325a41o26d1749ee89ab64d@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0711231257330.15887@alien.or.mcafeemobile.com>
References: <cfd18e0f0711220324l533d9048yf05c399019764b62@mail.gmail.com> 
 <Pine.LNX.4.64.0711220933330.7256@alien.or.mcafeemobile.com> 
 <cfd18e0f0711221048k538d05abk8e4303d5f90a6e1b@mail.gmail.com> 
 <Pine.LNX.4.64.0711221145410.7431@alien.or.mcafeemobile.com> 
 <20071122162430.48f55995.akpm@linux-foundation.org> 
 <Pine.LNX.4.64.0711221634510.7431@alien.or.mcafeemobile.com> 
 <20071122173437.e74890a8.akpm@linux-foundation.org> 
 <cfd18e0f0711230439m1d72abdle4d5050b0bd935a1@mail.gmail.com> 
 <20071123091254.45f4193d.akpm@linux-foundation.org> 
 <Pine.LNX.4.64.0711230928590.15603@alien.or.mcafeemobile.com>
 <a36005b50711231038j48325a41o26d1749ee89ab64d@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Nov 2007, Ulrich Drepper wrote:

> On Nov 23, 2007 9:29 AM, Davide Libenzi <davidel@xmailserver.org> wrote:
> > Yes, it's disabled, and yes, I'll repost today ...
> 
> I haven't seen the patch and don't feel like searching.  So I say it
> here: please mak sure you add a flags parameter to the system call
> itself (instead of adding it on as for eventfd and signalfd).  We need
> to be able to use O_CLOEXEC some way or another.

I'm more then OK about adding a flags parameter. If it was for me, I'd add 
it even to eventfd and signalfd. I asked Linus if he was OK about adding 
the flags parameter to all. He didn't reply, and I read that as "no".



- Davide


