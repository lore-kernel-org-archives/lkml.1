Return-Path: <linux-kernel-owner+w=401wt.eu-S1757219AbXJJVaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219AbXJJVaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 17:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756685AbXJJVaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 17:30:05 -0400
Received: from judo.dreamhost.com ([66.33.216.100]:59059 "EHLO
	judo.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721AbXJJVaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 17:30:03 -0400
X-Greylist: delayed 1503 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Oct 2007 17:30:03 EDT
Message-ID: <56055.190.54.55.123.1192050174.squirrel@webmail.0xff.cl>
In-Reply-To: <27658.1192045814@turing-police.cc.vt.edu>
References: <20071009194820.6c8d6e8d@0xff.cl>
    <470C2FA7.5030207@davidnewall.com> <20071010011523.7d6cca12@0xff.cl>
    <470C66A6.2060801@davidnewall.com>           
    <20071010094622.7b8121cf@0xff.cl>
    <27658.1192045814@turing-police.cc.vt.edu>
Date: Wed, 10 Oct 2007 14:02:54 -0700 (PDT)
Subject: Re: [PATCH] Reserve N process to root
From: g@0xff.cl
To: Valdis.Kletnieks@vt.edu
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.10a
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 10 Oct 2007 09:46:22 EDT, Gustavo Chain said:
>> El Wed, 10 Oct 2007 15:14:06 +0930
>> David Newall <david@davidnewall.com> escribió:
>> > That was what I thought you had in mind; it protects from some kind
>> > of fork bomb, right?  But it doesn't seem useful unless you guarantee
>> > having a process already running (with CAP_SYS_ADMIN) *before* the
>> > bomb goes off.
>>
>> Not really, because fork bomb will never reach maximum pid possible.
>> And root will always have a "slot" to kill desired processes.
>
> What David meant was that "root will always have a slot" doesn't
> *actually*
> help unless you *also* have a way to actually *spawn* such a process.  In
> order
> to do the ps, kill, and so on that you need to recover, you need to
> already
> have either a root shell available, or a way to *get* a root shell that
> doesn't
> rely on a non-root process (so /bin/su doesn't help here).
>
> Many distros will leave a /sbin/mingetty running on tty1 through tty6, and
> you *can* use those to get a root shell.  David's point is that without
> something like that already in place, the patch doesn't help....
>
>

but once you are logged in, how can you "spawn" processes (ps, kill, and
so on) if the limit is reached ?

