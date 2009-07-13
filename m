Return-Path: <linux-kernel-owner+w=401wt.eu-S1757081AbZGMUV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081AbZGMUV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 16:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757009AbZGMUV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 16:21:26 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52074 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756855AbZGMUVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 16:21:25 -0400
Date: Mon, 13 Jul 2009 22:21:16 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Arnd Bergmann <arnd@arndb.de>, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: compat ioctl32 for /dev/snapshot?
Message-ID: <20090713202116.GB2569@elf.ucw.cz>
References: <49FEB572.4010909@msgid.tls.msk.ru> <20090710162105.GA1469@ucw.cz> <4A592C09.8060104@msgid.tls.msk.ru> <200907121707.11152.arnd@arndb.de> <4A5AD963.5070908@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A5AD963.5070908@msgid.tls.msk.ru>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-07-13 10:51:15, Michael Tokarev wrote:
> Arnd Bergmann wrote:
>> On Sunday 12 July 2009, Michael Tokarev wrote:
>>> As I mentioned in my first email, I'm not the right person to
>>> do the patch.  But regardless, I spent about a day understanding
>>> this stuff (or trying to, anyway) - 100% useless day - and when
>>> I thought I have a patch someone else spoken up and said this
>>> way (compat_ioctl) is the wrong approach now.  And sent another,
>>> also trivial patch, adding compat calls right to the proper
>>> place in kernel/power.c.  Which (the patch) has been ignored
>>> too.
>>
>> I never got a reply from you saying whether or not the patch
>> I sent actually worked. If you or someone else can confirm it,
>> I'll resend with the fixes you mentioned.
>
> In order to (try to) check if it works or not, another userspace
> component has to be fixed to support 32/64 bit mode.  It's uswsusp,
> which currently assumes swap space structures are all 32bits.  So
> it isn't possible to immediately check if it works or not -- just
> ioctl(s) aren't enough.  Complete fix (kernel+user space) requires
> both, fixing all remaining (yet unknown) issues in old and new
> code on the way.

Well, there seems to be single structure in s2disk; that does not seem
that hard to fix.

> For now, I think it's best to let Pavel or Rafael to decide what
> to do with all this.

I don't currently have easy access to 64bit machine, so I guess it is
up to someone else.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
