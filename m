Return-Path: <linux-kernel-owner+w=401wt.eu-S1762307AbZDBSvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762307AbZDBSvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754678AbZDBSvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:51:06 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:61980 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbZDBSvD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:51:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bvGFjxNorpveE8TJYJxWV+Ua0k0buukhxh0kcYUUMiMKWoHiEtGQshVAU4o44lHpU3
         KPkVxjmAg4rpLUWl/7TikmHXwG23ooqoAYU2INKkWqaJMXSqGfbVlA8nuM/cQ+k3tcyU
         y2f8Vq6dE02BNCNbRRH4iDR+rU9pn8LHWNmWg=
MIME-Version: 1.0
In-Reply-To: <20090331123307.GG11808@duck.suse.cz>
References: <20090325151516.GB14881@atrey.karlin.mff.cuni.cz>
	 <20090325152234.GN23439@duck.suse.cz>
	 <a4423d670903250829w5e9304a7rce24f4220379620f@mail.gmail.com>
	 <20090325161556.GP23439@duck.suse.cz>
	 <a4423d670903251007r72058ca8m28275c1433ab2706@mail.gmail.com>
	 <20090325194316.GQ23439@duck.suse.cz>
	 <a4423d670903251538p3a7c180br1bcfe08c4f044c15@mail.gmail.com>
	 <20090331100150.GF11808@duck.suse.cz>
	 <a4423d670903310307i7acd31f0r4836beae14cfb92d@mail.gmail.com>
	 <20090331123307.GG11808@duck.suse.cz>
Date: Thu, 2 Apr 2009 22:50:59 +0400
Message-ID: <a4423d670904021150p5fcd1f82wefa68c839b2869a1@mail.gmail.com>
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

>> >  I'm helpless here. I don't see how we can miss a wakeup (plus you seem to
>> > be the only one reporting the bug). Could you please compile and test the kernel
>> > with the attached patch? It will print to kernel log when we go to sleep
>> > waiting for inode commit and when we send wakeups etc. When you hit the
>> > deadlock, please send me your kernel log. It should help with debugging why do
>> > we miss the wakeup. Thanks.
>>
>> Which patch?
>  Ups. Forgot to attach ;).

Cannot reproduce it on current 2.6.29-git. Strange.
It should already have all ext4/jbd2 patches from next-20090310,
but anyway it happened with 2.6.29-rc8 also.
I ran dbench in cycle on two indentical hosts for more than 24 hours
with no hang tasks.

I will try 2.6.29.
