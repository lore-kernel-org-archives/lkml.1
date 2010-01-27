Return-Path: <linux-kernel-owner+w=401wt.eu-S1751864Ab0A0Liz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab0A0Liz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 06:38:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915Ab0A0Liy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 06:38:54 -0500
Received: from 85-125-174-226.raaba.xdsl-line.inode.at ([85.125.174.226]:41757
	"EHLO merlin.merlin.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751398Ab0A0Lix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 06:38:53 -0500
X-Greylist: delayed 492 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jan 2010 06:38:53 EST
Message-ID: <4B6023DF.5070605@reinelt.co.at>
Date: Wed, 27 Jan 2010 12:30:39 +0100
From: Michael Reinelt <michael@reinelt.co.at>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.0.7) Gecko/20061013 Thunderbird/1.5.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Chris Wilson <chris@chris-wilson.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roman Jarosz <kedgedev@gmail.com>, A Rojas <nqn1976list@gmail.com>,
       "A. Boulan" <arnaud.boulan@libertysurf.fr>, jcnengel@googlemail.com,
       rientjes@google.com, earny@net4u.de, linux-kernel@vger.kernel.org,
       intel-gfx@lists.freedesktop.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       stable@kernel.org
Subject: Re: [PATCH] drm/i915: Selectively enable self-reclaim
References: <alpine.LFD.2.00.1001270252290.24253@localhost.localdomain> <1264590844-22972-1-git-send-email-chris@chris-wilson.co.uk> <4B602186.8050303@cs.helsinki.fi>
In-Reply-To: <4B602186.8050303@cs.helsinki.fi>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Pekka Enberg schrieb:
> Chris Wilson kirjoitti:
>> Having missed the ENOMEM return via i915_gem_fault(), there are probably
>> other paths that I also missed. By not enabling NORETRY by default these
>> paths can run the shrinker and take memory from the system (but not from
>> our own inactive lists because our shrinker can not run whilst we hold
>> the struct mutex) and this may allow the system to survive a little
>> longer
>> whilst our drivers consume all available memory.
>>
>> References:
>>   OOM killer unexpectedly called with kernel 2.6.32
>>   http://bugzilla.kernel.org/show_bug.cgi?id=14933
>>
>> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
>> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
>> Cc: Eric Anholt <eric@anholt.net>
>> Cc: stable@kernel.org
> 
> Roman, can you give this patch a spin?

I'm willing to test it, too (I can easily reproduce the problem), but I don't use (and know nothing about) git. Is there
a way for me to test it?


-- 
Michael Reinelt <michael@reinelt.co.at>
http://home.pages.at/reinelt
GPG-Key 0xDF13BA50
ICQ #288386781
