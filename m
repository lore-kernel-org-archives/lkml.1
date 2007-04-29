Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbXD2Do3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbXD2Do3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 23:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754543AbXD2Do2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 23:44:28 -0400
Received: from smtpout.mac.com ([17.250.248.175]:52029 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754518AbXD2Do1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 23:44:27 -0400
In-Reply-To: <alpine.LFD.0.98.0704281640480.9964@woody.linux-foundation.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <200704281950.30405.rjw@sisk.pl> <alpine.LFD.0.98.0704281421140.9964@woody.linux-foundation.org> <200704290103.38409.rjw@sisk.pl> <alpine.LFD.0.98.0704281640480.9964@woody.linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <5D9C407E-C5BE-434D-86B7-9EA58331F35D@mac.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Back to the future.
Date: Sat, 28 Apr 2007 23:43:27 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 28, 2007, at 19:45:01, Linus Torvalds wrote:
> On Sun, 29 Apr 2007, Rafael J. Wysocki wrote:
>> Well, I'm not sure whether or not that still would have been the  
>> case if we had stopped to freeze kernel threads for the  
>> hibernation/suspend.
>
> Did you miss the email where Paul pointed out that Mac/PowerPC  
> didn't use to do any of this? And apparently never had any issues  
> with it? And probably worked more reliably several years ago than  
> suspend/hibernation
> does _today_?

Still works pretty reliably; the last time my PowerBook G4 was  
rebooted was 6 weeks ago.  Once every 60 suspends or so the kernel  
USB driver gets really confused and doesn't wake up the USB  
controller properly, leading to dead keyboard/mouse, but other than  
that I never have problems.  I wouldn't be surprised if I could  
comment out 90% of the "suspend" code and still have it work, the  
hardware in is is incredibly robust.  I can even swap batteries while  
it's in suspend-to-RAM, as long as I do it in less than 45 sec or so;  
I get around 6-7 days of suspend-to-RAM time on a full charge.

Cheers,
Kyle Moffett

