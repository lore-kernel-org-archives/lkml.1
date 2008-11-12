Return-Path: <linux-kernel-owner+w=401wt.eu-S1752707AbYKLAKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbYKLAKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:10:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbYKLAJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:09:57 -0500
Received: from rn-out-0910.google.com ([64.233.170.189]:33739 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbYKLAJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:09:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kmasFsZsIoBjzw/olo+g8LC16xitZrhum/TmjpXDdRGGbbYNDZ7xEAuI213kLIQOSq
         Xj9/oQPm9y/xLtATN5Iersbk/9wPoDxXB09ZYzXCj/uhn+IjttQTc2GRXwtGx74DonXD
         +O6fXo1o2HnOBFMeg7bxUBbzpwSgA8aDYk2RM=
Message-ID: <a4423d670811111609l37dcfe6bme277692b5206b5ec@mail.gmail.com>
Date: Wed, 12 Nov 2008 03:09:54 +0300
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: 2.6.28-rc4: BUG: spinlock lockup on CPU#0
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
       kernel-testers@vger.kernel.org, rjw@sisk.pl
In-Reply-To: <20081111.154902.11426409.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081111233230.GC12456@orion>
	 <20081111.154902.11426409.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/12 David Miller <davem@davemloft.net>:
> From: Alexander Beregalov <a.beregalov@gmail.com>
> Date: Wed, 12 Nov 2008 02:32:30 +0300
>
>> It is on sparc64 (Ultra 10). 2.6.28-rc4-00011-g3ad4f59
>>
>> BUG: spinlock lockup on CPU#0, metalog/1322, 00000000007f1430
>> Kernel panic - not syncing: Aiee, killing interrupt handler!
>>
>> It seems Sysrq does not work.
>>
>> David, how can I provide more info before I reboot it ?
>>
>> Full dmesg:
>
> Hmm, this BUG message should have given you a register dump and a
> backtrace.
>
> Can you give it a "Alt-SysRQ-p" and show the output?
No, sysrq does not work, even Stop-A does not work now.
How could it be.

>
> Actually, if you got this over a serial console or
> similar, you're not getting the register dump because
> the console loglevel is filtering them out.
Yes, I use netconsole.

>
> If that's what's happening, reboot with "ignore_loglevel"
> (I always boot with this option, by adding it to the
> default kernel command line options in /etc/silo.conf)
>
> Also, in situations where the system is already booted and
> you want to see things like the Alt-SysRQ-p register dumps
> on the console, you'll need to type something like
> "Alt-SysRQ-8" to bump the console log level.

Yes, I know, thanks.

Ok, I have rebooted it, let's hope this will happen again...

Hm, fsck says Superblock write time is in future.
But rtc-m48t59 works correctly now
