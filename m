Return-Path: <linux-kernel-owner+w=401wt.eu-S1750991AbXCTTkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750991AbXCTTkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 15:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbXCTTkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 15:40:55 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:35858 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbXCTTky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 15:40:54 -0400
Message-ID: <4600389E.6030901@gmail.com>
Date: Tue, 20 Mar 2007 20:40:14 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.osdl.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.21-rc4-mm1
References: <20070319205623.299d0378.akpm@linux-foundation.org> <45FFF026.4030502@gmail.com> <20070320080944.9cb3c765.akpm@linux-foundation.org> <20070320183821.GD2670@elf.ucw.cz>
In-Reply-To: <20070320183821.GD2670@elf.ucw.cz>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Muni-Spam-TestIP: 147.251.48.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 20 Mar 2007 20:40:17 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek napsal(a):
> Hi!
> 
>>> Andrew Morton napsal(a):
>>>>   http://userweb.kernel.org/~akpm/2.6.21-rc4-mm1/
>>> I'm getting this while trying to swsusp:
>>> Stopping tasks ...
>>> Stopping kernel threads timed out after 20 seconds (1 tasks refusing to freeze):
>>>  swapper
>>>  Restarting tasks ... done.
>>>
>>> What to test? Enable PM_DEBUG?
> 
> Is it repeatable? Freezer normally works better than that.

Yes, at least it happened 3 times consecutively, when I tried to asleep the
machine, then I turned it off.

>> Also, it might be useful to add a temporary /proc/freeze-unfreeze thing
>> which will simply do a freeze/unfreeze cycle.  Then we can apply various
>> workloads to the machine while madly stressing the freezer code.  
> 
> echo testproc > /sys/power/disk; echo disk > /sys/power/state ... is
> pretty much what you want.

Ok, I'll try this.

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
