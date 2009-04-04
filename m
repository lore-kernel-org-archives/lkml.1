Return-Path: <linux-kernel-owner+w=401wt.eu-S1756263AbZDDVJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbZDDVJr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 17:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbZDDVJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 17:09:36 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:56496 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbZDDVJe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 17:09:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ANWW2OozEcKJmMFGi6hx9SyKtv6MPXXtod1nTtpTJv5F3xW/iUYZvk/iEitXrHxGen
         8oAxlOwlldex9zyodPi1SzlPPadqKMOIPgLpcNTEmzkAkaFBralhp7nEflqa5GG/H/7I
         Qj67uCYjN36mruy4ZarREDF58i8a8RXfLJMOU=
MIME-Version: 1.0
In-Reply-To: <a4423d670904021150p5fcd1f82wefa68c839b2869a1@mail.gmail.com>
References: <20090325151516.GB14881@atrey.karlin.mff.cuni.cz>
	 <a4423d670903250829w5e9304a7rce24f4220379620f@mail.gmail.com>
	 <20090325161556.GP23439@duck.suse.cz>
	 <a4423d670903251007r72058ca8m28275c1433ab2706@mail.gmail.com>
	 <20090325194316.GQ23439@duck.suse.cz>
	 <a4423d670903251538p3a7c180br1bcfe08c4f044c15@mail.gmail.com>
	 <20090331100150.GF11808@duck.suse.cz>
	 <a4423d670903310307i7acd31f0r4836beae14cfb92d@mail.gmail.com>
	 <20090331123307.GG11808@duck.suse.cz>
	 <a4423d670904021150p5fcd1f82wefa68c839b2869a1@mail.gmail.com>
Date: Sun, 5 Apr 2009 01:09:31 +0400
Message-ID: <a4423d670904041409i271c8abbyf5b74d656eeb363f@mail.gmail.com>
Subject: Re: next-20090310: ext4 hangs
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Theodore Tso <tytso@mit.edu>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       sparclinux@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/2 Alexander Beregalov <a.beregalov@gmail.com>:
>>> >  I'm helpless here. I don't see how we can miss a wakeup (plus you seem to
>>> > be the only one reporting the bug). Could you please compile and test the kernel
>>> > with the attached patch? It will print to kernel log when we go to sleep
>>> > waiting for inode commit and when we send wakeups etc. When you hit the
>>> > deadlock, please send me your kernel log. It should help with debugging why do
>>> > we miss the wakeup. Thanks.
>>>
>>> Which patch?
>>  Ups. Forgot to attach ;).
>
> Cannot reproduce it on current 2.6.29-git. Strange.
> It should already have all ext4/jbd2 patches from next-20090310,
> but anyway it happened with 2.6.29-rc8 also.
> I ran dbench in cycle on two indentical hosts for more than 24 hours
> with no hang tasks.
>
> I will try 2.6.29.

I cannot reproduce it with vanilla v2.6.29.
It seems the problem has gone.
Thanks Jan.

The patch output:
[133886.375874] JBD2: Waiting for ino 1062
[133886.376372] JBD2: Waking up sleeper on ino 1062
[133886.376824] JBD2: Woken on ino 1062
[134611.108451] JBD2: Waiting for ino 1102
[134611.108903] JBD2: Waking up sleeper on ino 1102
[134611.109787] JBD2: Woken on ino 1102
[134611.132912] JBD2: Waiting for ino 1074
[134611.133311] JBD2: Waking up sleeper on ino 1074
[134611.133707] JBD2: Woken on ino 1074
