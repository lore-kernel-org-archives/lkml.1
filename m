Return-Path: <linux-kernel-owner+w=401wt.eu-S1758085AbZBBS3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085AbZBBS3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 13:29:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbZBBS3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 13:29:21 -0500
Received: from mail-gx0-f21.google.com ([209.85.217.21]:54176 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbZBBS3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 13:29:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FmRwXoTdBDmr7Jgulz/PtRkg/wHFmZaUI7PYb2hPD3feOdJ4xETqx5uJZsR1v0YVn5
         UiwljKnw/Dkp+mxqOnQslmwO1gWQXhIJ98B1EwR+rym2L05MotDzUHocw0h8UTcIa+Dt
         mzs48J11tAQ6VKi59F52xpzKyJLgxOLX9KcSs=
MIME-Version: 1.0
In-Reply-To: <20090202180811.GC1394@elte.hu>
References: <1233385816.17794.16.camel@localhost.localdomain>
	 <20090131164410.GA11189@elte.hu>
	 <1233469811.5846.14.camel@localhost.localdomain>
	 <20090201103936.GA30157@elte.hu> <20090201164915.GA29264@elte.hu>
	 <8bd0f97a0902020911h6cc45be0m8b2affb5a531d160@mail.gmail.com>
	 <20090202180811.GC1394@elte.hu>
Date: Mon, 2 Feb 2009 13:29:18 -0500
Message-ID: <8bd0f97a0902021029xa07a4d2n9779137a7d2bb9cd@mail.gmail.com>
Subject: Re: [git pull -tip] headers_check fixes for other architectures
From: Mike Frysinger <vapier.adi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       hskinnemoen@atmel.com, cooloney@kernel.org, tony.luck@intel.com,
       ralf@linux-mips.org, dhowells@redhat.com, matthew@wil.cx,
       chris@zankel.net, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 2, 2009 at 13:08, Ingo Molnar wrote:
> * Mike Frysinger wrote:
>> On Sun, Feb 1, 2009 at 11:49, Ingo Molnar wrote:
>> > These are the remaining ones on x86:
>> >
>> >     17 /dev/shm/tip/usr/include/linux/reiserfs_fs.h
>> >     12 /dev/shm/tip/usr/include/linux/soundcard.h
>> >      6 /dev/shm/tip/usr/include/asm/setup.h
>> >      3 /dev/shm/tip/usr/include/linux/nubus.h
>> >      2 /dev/shm/tip/usr/include/linux/in6.h
>> >      1 /dev/shm/tip/usr/include/mtd/jffs2-user.h
>> >      1 /dev/shm/tip/usr/include/linux/socket.h
>> >      1 /dev/shm/tip/usr/include/linux/coda_psdev.h
>> >      1 /dev/shm/tip/usr/include/asm/prctl.h
>> >
>> > They are all of the "extern's make no sense in userspace" type. What was
>> > the verdict, are they worth touching, or should we turn off this warning
>> > in 'make headers_check'?
>>
>> the warning wouldnt have been added if it didnt make sense ... like it
>> says, prototypes for kernel functions make no sense in userspace headers
>
> the existence of a warning does not justify it. For example the CONFIG_*
> warnings were deemed largely bogus and were removed.

kernel function prototypes make no sense in userspace, especially
considering how much effort goes into avoiding namespace pollution.
-mike
