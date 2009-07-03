Return-Path: <linux-kernel-owner+w=401wt.eu-S1754232AbZGCKay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbZGCKay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 06:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbZGCKaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 06:30:46 -0400
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:37500 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbZGCKap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 06:30:45 -0400
Message-ID: <4A4DDD54.9030206@free.fr>
Date: Fri, 03 Jul 2009 12:28:36 +0200
From: Albert ARIBAUD <albert.aribaud@free.fr>
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Changli Gao <xiaosuo@gmail.com>, Amerigo Wang <xiyou.wangcong@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: PROPOSAL: extend pipe() to support NULL argument.
References: <20090703015554.GB5880@cr0.nay.redhat.com>	 <20090703030008.GD5880@cr0.nay.redhat.com>	 <412e6f7f0907022108p7c533ed2wd16fceb0f282ed62@mail.gmail.com>	 <20090703051917.GE5880@cr0.nay.redhat.com>	 <412e6f7f0907022242r52ad981fyd51c2a55f41ab228@mail.gmail.com>	 <20090703071504.GG5880@cr0.nay.redhat.com>	 <412e6f7f0907030040v6133badat7058186a01d78f44@mail.gmail.com>	 <20090703081655.GH5880@cr0.nay.redhat.com>	 <412e6f7f0907030127u3d6806dfo9168600e7c71b241@mail.gmail.com>	 <20090703094229.GI5880@cr0.nay.redhat.com> <412e6f7f0907030259m5556ee2fobbb58d377bce4d17@mail.gmail.com>
In-Reply-To: <412e6f7f0907030259m5556ee2fobbb58d377bce4d17@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changli Gao a écrit :

> Yea, in many cases, max fd number must be enlarged. More fds means
> more memory. Although memory is cheaper today, we have to do our best
> to save money.

Sorry for interrupting, but I don't see how pipe could return a single fd, 
considering there are two (partly) independent ends, each being read (resp. 
written) in their own time, and an fd has only one "current read/write 
position" IIUC.

If the proposal is to have two independent positions (one for reads and one 
for writes) for a single fd, then I am not sure the gain in the number of 
fds used is worth the loss in the increased size of the fd structure.

Am I missing something?

Amicalement,
-- 
Albert.
