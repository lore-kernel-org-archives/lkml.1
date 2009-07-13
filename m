Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbZGMGvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbZGMGvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 02:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750934AbZGMGvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 02:51:18 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:45564 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbZGMGvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 02:51:18 -0400
Message-ID: <4A5AD963.5070908@msgid.tls.msk.ru>
Date: Mon, 13 Jul 2009 10:51:15 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Pavel Machek <pavel@ucw.cz>, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: compat ioctl32 for /dev/snapshot?
References: <49FEB572.4010909@msgid.tls.msk.ru> <20090710162105.GA1469@ucw.cz> <4A592C09.8060104@msgid.tls.msk.ru> <200907121707.11152.arnd@arndb.de>
In-Reply-To: <200907121707.11152.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Sunday 12 July 2009, Michael Tokarev wrote:
>> As I mentioned in my first email, I'm not the right person to
>> do the patch.  But regardless, I spent about a day understanding
>> this stuff (or trying to, anyway) - 100% useless day - and when
>> I thought I have a patch someone else spoken up and said this
>> way (compat_ioctl) is the wrong approach now.  And sent another,
>> also trivial patch, adding compat calls right to the proper
>> place in kernel/power.c.  Which (the patch) has been ignored
>> too.
> 
> I never got a reply from you saying whether or not the patch
> I sent actually worked. If you or someone else can confirm it,
> I'll resend with the fixes you mentioned.

In order to (try to) check if it works or not, another userspace
component has to be fixed to support 32/64 bit mode.  It's uswsusp,
which currently assumes swap space structures are all 32bits.  So
it isn't possible to immediately check if it works or not -- just
ioctl(s) aren't enough.  Complete fix (kernel+user space) requires
both, fixing all remaining (yet unknown) issues in old and new
code on the way.

For now, I think it's best to let Pavel or Rafael to decide what
to do with all this.

Thanks!

/mjt
