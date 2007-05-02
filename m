Return-Path: <linux-kernel-owner+w=401wt.eu-S2993201AbXEBN5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993201AbXEBN5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 09:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993204AbXEBN5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 09:57:09 -0400
Received: from wx-out-0506.google.com ([66.249.82.226]:56693 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993201AbXEBN5G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 09:57:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=a1H0Oc3YWmGymp4SeEd42ofaIRtYmF8EXXJkjVEkKFCCLKs6xeaAnU/UpgKMlAJvYBzEWZXU0ZjAUVkvB1SjkcTy8e5Lk9AoiLy/rB474s219RJZNqH7dEEvUSOhaQPi/pFnpsmIcDf/dRVU0oKJnalmOz8UA60XuOnyE+p6d7A=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [git pull] New firewire stack
Date: Wed, 2 May 2007 09:56:59 -0400
User-Agent: KMail/1.9.6
Cc: Olaf Hering <olh@suse.de>,
       Kristian =?iso-8859-1?q?H=F8gsberg?= <krh@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>
References: <4637A29F.6070302@redhat.com> <20070502122147.GA31215@suse.de> <4638888B.4080908@s5r6.in-berlin.de>
In-Reply-To: <4638888B.4080908@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705020956.59804.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 May 2007, Stefan Richter wrote:
>Olaf Hering wrote:
>> On Tue, May 01, Kristian Høgsberg wrote:
>>>   drivers/firewire/Kconfig          |   60 ++
>>
>> NACK.
>> Upgrade the current drivers/ieee1394/ with the new code,
>
>Last time I believe I was the only one who asked whether to put it into
>drivers/ieee1394 instead of another directory.  Of course I acknowledge
>that everytime a new review round is started, people do reconsider.
>Especially since we had a gap of a few months since the last LKML review.
>
>> and keep all existing module names.
>
>I'm impartial to that.  Using same names might ease the transition from
>the userspace side, as far as there is userland which relies on module
>names.
>
>A certain drawback of same names would be that geeks cannot install both
>stacks at once during the transition period.  Therefore, checking
>whether eventual problems are in fact regressions involves a module
>unload/ configure/ build/ install/ reload cycle, instead of just module
>unload/ reload.  This especially means we can only get help from testers
>who are able to build kernels.
>
>Other opinions?

I can and do build my own kernels so that's not a problem for me.  I also have 
a firewire movie camera that went through absolute hell the last time a 
firewire upgrade came by, and it was over 5 months before I had a working 
kino install again.  So I'd vote unconditionally to have 2 trees to select 
from at module load time until the shakeout has produced usable code in the 
2nd tree.

>From me, its a definite ACK.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
I owe, I owe,
It's off to work I go...
