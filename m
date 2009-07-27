Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbZG0Ui2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbZG0Ui2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 16:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754643AbZG0Ui2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 16:38:28 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:42442 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbZG0Ui1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 16:38:27 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ray Lee <ray-lk@madrabbit.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk>
	<87bpn7mzli.fsf@devron.myhome.or.jp>
	<20090727115723.1e8de60e@lxorguk.ukuu.org.uk>
	<873a8iqqgv.fsf@devron.myhome.or.jp>
	<20090727142303.41096bf5@lxorguk.ukuu.org.uk>
	<877hxujkuv.fsf@devron.myhome.or.jp>
	<20090727145805.690afe5d@lxorguk.ukuu.org.uk>
	<87fxci6ub9.fsf@devron.myhome.or.jp> <20090727161424.GA4233@skywalker>
	<20090727174252.2d987830@lxorguk.ukuu.org.uk>
	<20090727171213.GB4233@skywalker> <87skgikjr8.fsf@devron.myhome.or.jp>
	<alpine.LFD.2.01.0907271237250.25224@localhost.localdomain>
Date: Tue, 28 Jul 2009 05:38:24 +0900
In-Reply-To: <alpine.LFD.2.01.0907271237250.25224@localhost.localdomain>
	(Linus Torvalds's message of "Mon, 27 Jul 2009 12:40:11 -0700 (PDT)")
Message-ID: <87ocr5dfpb.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Tue, 28 Jul 2009, OGAWA Hirofumi wrote:
>> 
>> If I read that part of emacs correctly, it seems to be assuming the data
>> was already sent to master side if the child process was exited.
>
> That sounds like a rather obvious assumption.
>
> Aren't pty's flushing the data at flush() time? Which should be happening 
> when the child process exits and closes the pty slave.

For tty, I guess yes. However, now, pty is pushing the data to other
side by background, I'm not sure at all though, I guess ppp is requiring it.

> So at what point do we just admit that the commit that caused all this was 
> a buggy pile of sh*t and just revert it?

Also, I'm not sure though, I guess it depends on the bug which was fixed
by the commit.

I don't know about ppp problem at all. So, personally I'm ok either way
- we revert it and try to fix this for next merge window, or continue to
fix this for a while.

Alan-san?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
