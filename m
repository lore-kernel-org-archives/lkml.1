Return-Path: <linux-kernel-owner+w=401wt.eu-S1766922AbXEBUIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766922AbXEBUIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 16:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766936AbXEBUIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 16:08:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766922AbXEBUIV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 16:08:21 -0400
Message-ID: <4638EEA6.9020609@redhat.com>
Date: Wed, 02 May 2007 16:03:50 -0400
From: =?UTF-8?B?S3Jpc3RpYW4gSMO4Z3NiZXJn?= <krh@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>, Olaf Hering <olh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>
Subject: Re: [git pull] New firewire stack
References: <4637A29F.6070302@redhat.com> <20070502122147.GA31215@suse.de> <4638888B.4080908@s5r6.in-berlin.de> <20070502152732.GG3531@stusta.de>
In-Reply-To: <20070502152732.GG3531@stusta.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Wed, May 02, 2007 at 02:48:11PM +0200, Stefan Richter wrote:
>> Olaf Hering wrote:
>>> On Tue, May 01, Kristian Høgsberg wrote:
>>>
>>>>   drivers/firewire/Kconfig          |   60 ++
>>> NACK.
>>> Upgrade the current drivers/ieee1394/ with the new code,
>> Last time I believe I was the only one who asked whether to put it into
>> drivers/ieee1394 instead of another directory.  Of course I acknowledge
>> that everytime a new review round is started, people do reconsider.
>> Especially since we had a gap of a few months since the last LKML review.
>>
>>> and keep all existing module names.
>> I'm impartial to that.  Using same names might ease the transition from
>> the userspace side, as far as there is userland which relies on module
>> names.
>>
>> A certain drawback of same names would be that geeks cannot install both
>> stacks at once during the transition period.  Therefore, checking
>> whether eventual problems are in fact regressions involves a module
>> unload/ configure/ build/ install/ reload cycle, instead of just module
>> unload/ reload.  This especially means we can only get help from testers
>> who are able to build kernels.
>>
>> Other opinions?
> 
> An advantage of changing the names is that they are now prefixed.
> But looking at them, there will again be the point whether everyone will 
> think that "fw" is firmware, and perhaps switching to the (although 
> longer) prefix "firewire" might make sense?

I like "firewire" better, I'm already using that for the userspace header 
file.  Renaming the modules to firewire-core, firewire-ohci and firewire-sbp2 
sounds good to me.

Kristian

