Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031004Ab0B1Dmt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 22:42:49 -0500
Received: from mail.windriver.com ([147.11.1.11]:64590 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968691Ab0B1Dms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 22:42:48 -0500
Message-ID: <4B89E622.1070009@windriver.com>
Date: Sat, 27 Feb 2010 21:42:26 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       kgdb-bugreport@lists.sourceforge.net
Subject: Re: [PATCH 14/28] kgdboc,keyboard: Keyboard driver for kdb with kgdb
References: <1267132893-23624-1-git-send-email-jason.wessel@windriver.com> <1267132893-23624-15-git-send-email-jason.wessel@windriver.com> <20100226075755.GC17062@core.coreip.homeip.net> <4B87C8DF.4000805@windriver.com> <20100227075927.GB793@core.coreip.homeip.net>
In-Reply-To: <20100227075927.GB793@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Feb 2010 03:42:27.0354 (UTC) FILETIME=[0C0817A0:01CAB828]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
>
>> The original logic for putting next to the keyboard.c was because they
>> are both fighting for the same HW.  Please let me know if this changes
>> your mind, else I will go ahead and move the keyboard implementation
>> into the kernel/debug/kdb.
>>
>>     
>
> It does not behause in 2.6 the driver talking to the i8042 is called
> i8042.c and it is located in drivers/input/serio.
> drivers/char/keyboard.c does not talk directly to hardware anymore and
> pc_keyb.c is long gone.
>
> Given the fact that your code does not implement a character device I do
> not see any reason for it to live in drivers/char.
>   

I buy your logic.   I have moved the kdb_keyboard.c to
kernel/debug/kdb/kdb_keyboard.c.

Can I assume we have reached closure on this patch for the short term?

Eventually I would like to to get rid of kdb_keyboard.c entirely and
replace it with some kind of way to atomically poll the input devices,
but this is longer term.

Thanks,
Jason.
