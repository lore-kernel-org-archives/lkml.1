Return-Path: <linux-kernel-owner+w=401wt.eu-S1761551AbYHERbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761551AbYHERbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 13:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759113AbYHERbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 13:31:41 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:43253 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758259AbYHERbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 13:31:40 -0400
Message-ID: <2779.69.2.248.210.1217956249.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <20080805172115.GA29645@linux-sh.org>
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com>
    <Pine.LNX.4.64.0808051140150.6309@anakin>
    <33030.166.70.238.45.1217948565.squirrel@webmail.wolfmountaingroup.com>
    <200808060133.10457.nickpiggin@yahoo.com.au>
    <44919.166.70.238.45.1217949560.squirrel@webmail.wolfmountaingroup.com>
    <20080805172115.GA29645@linux-sh.org>
Date: Tue, 5 Aug 2008 11:10:49 -0600 (MDT)
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
From: jmerkey@wolfmountaingroup.com
To: "Paul Mundt" <lethal@linux-sh.org>, jmerkey@wolfmountaingroup.com,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Josh Boyer" <jwboyer@gmail.com>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> That's great, except kgdb has existed in the kernel for various
> architectures well before that as well. ppc32's stub dates back to 1998,
> sh had it since 2001, mips around the same time, etc, etc. While the
> current rework and tidying of the stubs is something new, kgdb itself is
> not.
>
>> > But the ideal outcome would be if you could contribute patches to
>> > kgdb to the point where it is as good as mdb. It is already in the
>> > tree and supported by a handful of architectures... any chance of
>> > that? (I don't know kernel debugger code, so I ask as an interested
>> > user)
>>
>> I plan to work on kdb and yes, there is a version of this that runs
>> as an alternate debugger of kdb - you can even switch back and forth
>> between them - but that misses the point as well.
>>
> kgdb and kdb are totally different things, kgdb is what is generally
> available and worth improving in-kernel.
>
> While it's certainly good to have options, having multiple in-kernel
> debuggers is not going to help matters for the vast majority of users. I
> agree with Nick, it would be nice to see what we have in-kernel being
> extended and worked on by more people, especially those with a background
> in these things.


Not your call to make.  Kernel Debuggers are very personal choices and
its pure arrogance to assume any of us can make a choice for someone else
with tools.  My tastes in debuggers is like my tastes in food, or women,
or what kin of toothbrush I like to use.

>
> On the other hand, it seems like there's sufficient interest in your
> project out-of-tree, so there's not really much point in merging it if
> you're content with the interface as it exists today and it continues to
> work for your users.
>
> One of the things we can do however is try to provide cleaner
> abstractions for the various debuggers to tie in to, so we don't end up
> with each debugger piling on its own set of ifdefs in all of the same
> places (int3 handling comes to mind, which you could already do more
> cleanly through the die chain today). Perhaps it would be more useful to
> see what sort of hooks mdb wants in the architecture and core code, how
> those overlap with kgdb, and how we might extend kgdb in areas where mdb
> is more feature complete.
>


This is a great suggestion.  mdb already uses an alternate debugger
interface with the hooks into traps_XX.c and reboot_XX.c.   I still would
like to see it in kernel.  but an alternate debugger interface as you
point
out is almost a necessity at this point.  there's a good example in
mdb.c and mdb-list.c.


Jeff

