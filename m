Return-Path: <linux-kernel-owner+w=401wt.eu-S1759590AbZCZRGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759590AbZCZRGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 13:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755648AbZCZRG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 13:06:29 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:55924 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798AbZCZRG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 13:06:28 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: ext3 IO latency measurements (was: Linux 2.6.29)
References: <20090325150041.GM32307@mit.edu>
	<alpine.LFD.2.00.0903251008120.3032@localhost.localdomain>
	<20090325185824.GO32307@mit.edu>
	<alpine.LFD.2.00.0903251341050.3032@localhost.localdomain>
	<20090325215137.GQ32307@mit.edu>
	<alpine.LFD.2.00.0903251613300.3032@localhost.localdomain>
	<20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu>
	<20090326113705.GV32307@mit.edu> <20090326140312.GB14822@elte.hu>
	<20090326144707.GA6239@mit.edu>
	<alpine.LFD.2.00.0903260914440.3032@localhost.localdomain>
X-Yow: Tex SEX!  The HOME of WHEELS!  The dripping of COFFEE!!  Take me
 to Minnesota but don't EMBARRASS me!!
Date: Thu, 26 Mar 2009 18:06:19 +0100
In-Reply-To: <alpine.LFD.2.00.0903260914440.3032@localhost.localdomain> (Linus
	Torvalds's message of "Thu, 26 Mar 2009 09:20:14 -0700 (PDT)")
Message-ID: <m2d4c4b4dw.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> And quite frankly, even if you then _manually_ put 'relatime' in 
> /etc/fstab, the default Fedora install will totally ignore it. Why? 
> Because it mounts the root partition while using initrd, and totally 
> ignores /etc/fstab.

That works here in openSUSE 11.1.  The initrd remounts the rootfs with
any options it founds in /etc/fstab.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
