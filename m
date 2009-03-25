Return-Path: <linux-kernel-owner+w=401wt.eu-S1762082AbZCYSi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762082AbZCYSi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 14:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbZCYSiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 14:38:46 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:22195 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754335AbZCYSip convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 14:38:45 -0400
X-BigFish: VPS-21(zz1432R98dR1805M936fK873fn7cf0izz1202hzzz2fh6bh63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 5,
Message-ID: <49CA79FA.8080906@am.sony.com>
Date: Wed, 25 Mar 2009 11:37:46 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: Anyone working on ftrace function graph support on ARM?
References: <49C936CA.8070800@am.sony.com> <20090324213618.GC5975@nowhere> <49C95EAF.7030901@gmail.com> <20090324224857.GE5975@nowhere> <20090325084248.GF4697@n2100.arm.linux.org.uk> <49CA5CFF.8090908@am.sony.com> <20090325170533.GA4667@pengutronix.de> <20090325171727.GH2952@n2100.arm.linux.org.uk>
In-Reply-To: <20090325171727.GH2952@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-OriginalArrivalTime: 25 Mar 2009 18:37:47.0544 (UTC) FILETIME=[CB4F9180:01C9AD78]
X-SEL-encryption-scan: scanned
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:
> On Wed, Mar 25, 2009 at 06:05:33PM +0100, Uwe Kleine-K�nig wrote:
>> On Wed, Mar 25, 2009 at 09:34:07AM -0700, Tim Bird wrote:
>>> Russell King - ARM Linux wrote:
>>>> As pointed out in my previous mail, identifying where on the stack the
>>>> return address is stored is only possible for OABI with frame pointers.
>>>>
>>>> EABI will probably be possible with the stack unwinding code, but it
>>>> probably won't be cheap.  The EABI unwinder is scheduled for merging
>>>> during the present now-open merge window.
>> EABI with frame pointers should work, too, shouldn't it?
> 
> Yes, as I said at the top of my reply dated Wed, 25 Mar 2009 09:57:51 +0000

It turns out you can't use -pg and -fomit-frame-pointers at the same time.
At least, my gcc complains about this:
$ make
arm-sony-linux-gnueabi-dev-gcc -g -pg -fomit-frame-pointer -o hello hello.c
arm-sony-linux-gnueabi-dev-gcc: -pg and -fomit-frame-pointer are incompatible
make: *** [hello] Error 1

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

