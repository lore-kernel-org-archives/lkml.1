Return-Path: <linux-kernel-owner+w=401wt.eu-S1755751Ab0A1STP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab0A1STP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 13:19:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755554Ab0A1STO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 13:19:14 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:51650 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964Ab0A1STN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 13:19:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:message-id:in-reply-to:user-agent;
        b=Z9Lv5NmdYl2tCM2cYOMpDLhESq6c8tUAGYFt4mFoYil8fvyMkWg2JGkp4yMZiBrOhN
         raPKypJGNwgAaraSxHXy9YRCD/t549+8hrdmmAW+TsA1epmZbrPeSTanraaDEgHOy8jb
         fuz0q1BjTeC+2DTXLys/eZdxK6+aGU52E+igA=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Michael Reinelt" <michael@reinelt.co.at>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: "Chris Wilson" <chris@chris-wilson.co.uk>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "A Rojas" <nqn1976list@gmail.com>,
       "A. Boulan" <arnaud.boulan@libertysurf.fr>, jcnengel@googlemail.com,
       rientjes@google.com, earny@net4u.de, linux-kernel@vger.kernel.org,
       intel-gfx@lists.freedesktop.org,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Hugh Dickins" <hugh.dickins@tiscali.co.uk>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Eric Anholt" <eric@anholt.net>, stable@kernel.org
Subject: Re: [PATCH] drm/i915: Selectively enable self-reclaim
References: <alpine.LFD.2.00.1001270252290.24253@localhost.localdomain>
 <1264590844-22972-1-git-send-email-chris@chris-wilson.co.uk>
 <4B602186.8050303@cs.helsinki.fi> <4B610134.9020109@reinelt.co.at>
Date: Thu, 28 Jan 2010 19:21:47 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From: "Roman Jarosz" <kedgedev@gmail.com>
Message-ID: <op.u689ajucasvm2a@kedge>
In-Reply-To: <4B610134.9020109@reinelt.co.at>
User-Agent: Opera Mail/10.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jan 2010 04:15:00 +0100, Michael Reinelt  
<michael@reinelt.co.at> wrote:

>
>
> Pekka Enberg schrieb:
>> Chris Wilson kirjoitti:
>>> Having missed the ENOMEM return via i915_gem_fault(), there are  
>>> probably
>>> other paths that I also missed. By not enabling NORETRY by default  
>>> these
>>> paths can run the shrinker and take memory from the system (but not  
>>> from
>>> our own inactive lists because our shrinker can not run whilst we hold
>>> the struct mutex) and this may allow the system to survive a little
>>> longer
>>> whilst our drivers consume all available memory.
>>>
>>> References:
>>>   OOM killer unexpectedly called with kernel 2.6.32
>>>   http://bugzilla.kernel.org/show_bug.cgi?id=14933
>>>
>>> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>>> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>>> Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
>>> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
>>> Cc: Eric Anholt <eric@anholt.net>
>>> Cc: stable@kernel.org
>>
>> Roman, can you give this patch a spin?
>
> Applied to 2.6.33-rc5, stress-test under heavy load, no problem so far.  
> Looks fine!

Here it works too, thanks!

Roman

