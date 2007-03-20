Return-Path: <linux-kernel-owner+w=401wt.eu-S934056AbXCTUOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934056AbXCTUOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 16:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934063AbXCTUOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 16:14:12 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:46283 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934056AbXCTUOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 16:14:10 -0400
Message-ID: <46004080.6080202@gmail.com>
Date: Tue, 20 Mar 2007 21:13:52 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.osdl.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.21-rc4-mm1
References: <20070319205623.299d0378.akpm@linux-foundation.org> <45FFF026.4030502@gmail.com> <20070320080944.9cb3c765.akpm@linux-foundation.org> <20070320183821.GD2670@elf.ucw.cz> <4600389E.6030901@gmail.com> <20070320195659.GA3545@elf.ucw.cz>
In-Reply-To: <20070320195659.GA3545@elf.ucw.cz>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Muni-Spam-TestIP: 147.251.48.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 20 Mar 2007 21:13:54 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek napsal(a):
> Hi!
> 
>>>> Also, it might be useful to add a temporary /proc/freeze-unfreeze thing
>>>> which will simply do a freeze/unfreeze cycle.  Then we can apply various
>>>> workloads to the machine while madly stressing the freezer code.  
>>> echo testproc > /sys/power/disk; echo disk > /sys/power/state ... is
>>> pretty much what you want.
>> Ok, I'll try this.
> 
> It will not help you -- probably -- it is equivalent to just running
> s2ram. But it should make "successful" testing easier, because you no
> longer need machine with working suspend to test refrigerator.

Aha, I didn't read it carefully. Suspend is working, but not in this kernel.
I haven't tried s2ram in this version. Should I (I'm away from it) -- would
it show something?

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
