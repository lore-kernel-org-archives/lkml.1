Return-Path: <linux-kernel-owner+w=401wt.eu-S1757692AbYDIUk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692AbYDIUk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 16:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753919AbYDIUkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 16:40:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43031 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754587AbYDIUkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 16:40:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Justin Mattock" <justinmattock@gmail.com>
Subject: Re: mutex_unlock
Date: Wed, 9 Apr 2008 22:40:25 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <dd18b0c30804090017m75c97f81qf6428b377432f8b5@mail.gmail.com>
In-Reply-To: <dd18b0c30804090017m75c97f81qf6428b377432f8b5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804092240.26623.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 9 of April 2008, Justin Mattock wrote:
> Hello with testing out git(very cool); my first test was with
> 2.6.25-rc8-00194-g4cac04d ran vary smoothly;
> then I decided to pull the latest git (2.6.25-rc8-00208-g7180c4c)and
> see what I might find.
> upon reboot the system starts up giving me this:
> 
> Starting up
> Decompressing Linux Done
> Booting the kernel
> __   <-------blinking
> 
> I waited a few seconds or minutes but nothing;
> after reading earlier posts about something with a mutex_unlock maybe
> this was what I was experiencing.
> when loading a live cd and recompiling the same kernel, I noticed
> under kernel hacking;
> 
> RT Mutex debugging
> Built in scriptable tester for rt-mutexes
> Spinlock and rw-lock debugging
> Mutex debugging basic checks
> Lock debugging detect incorrect freeing of live locks
> Lock debugging prove locking correctness
> lock usage statistics
> Lock dependency engine debugging
> spinlock debugging sleep-inside-spinlock checking
> Locking API boot-time self-tests
> 
> With not knowing what I was doing I chose yes to all of these options,
> then reboot -f,
> The system booted up properly,
> 
> Is there a way where I can find out if this was what was going on?
> could this be something different?

Hm, interesting.

It looks like our locking debugging code may hide some issues ...

Thanks,
Rafael
