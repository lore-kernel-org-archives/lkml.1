Return-Path: <linux-kernel-owner+w=401wt.eu-S1764494AbXGPAfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764494AbXGPAfI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 20:35:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759934AbXGPAe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 20:34:57 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:35979
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758666AbXGPAe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 20:34:57 -0400
Date: Sun, 15 Jul 2007 17:28:27 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Latchesar Ionkov <lucho@ionkov.net>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       V9FS Developers <v9fs-developer@lists.sourceforge.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [V9fs-developer] [GIT PULL] 9p Patches for 2.6.23 merge window
In-Reply-To: <f158dc670707151730w5fedb53fq11367d1e6fb14d87@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0707151727220.25614@asgard.lang.hm>
References: <a4e6962a0707141320p376e51fcp4b1ceb681960e303@mail.gmail.com> 
 <alpine.LFD.0.999.0707151645561.20061@woody.linux-foundation.org>
 <f158dc670707151730w5fedb53fq11367d1e6fb14d87@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jul 2007, Latchesar Ionkov wrote:

> I thought that it is not a good idea to keep the v9fs_ prefix for code
> that is in different places (fs/9p and net/9p). If keeping the old
> prefix is more acceptable, I can create a new patch without the
> "v9fs_"->"p9_" renames.

do the code reorg and the name changes as two different patches. it makes 
it much easier to see that the rename doesn't change any functionality, 
and makes the code reorg much easier to see.

David Lang

> Thanks,
>    Lucho
>
> On 7/15/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>> 
>>
>>  On Sat, 14 Jul 2007, Eric Van Hensbergen wrote:
>> > 
>> >  The bulk of the changes were in the reorganization patch which mostly
>> >  moved files and interfaces around in preparation for work on an
>> >  in-kernel 9p server.
>>
>>  Please use "git diff -C --stat --summary" to generate the diffstat
>>  summary.
>>
>>  In particular, because you didn't use -C (or -M), git have you an
>>  old-style diffstat without renames, so the diffstat doesn't show that a
>>  lot of it was moving code around.
>>
>>  (That said, you seem to have changed names a lot too, so it's not pure
>>  code movement).
>> 
>> >  49 files changed, 5400 insertions(+), 5092 deletions(-)
>>
>>  With rename detection enabled, I get
>>
>>   36 files changed, 3444 insertions(+), 3130 deletions(-)
>>
>>  due to finding some (partially dubious) renames:
>>
>>   rename fs/9p/mux.h => include/net/9p/conn.h (53%)
>>   rename {fs => include/net}/9p/transport.h (59%)
>>   rename {fs => net}/9p/conv.c (55%)
>>   rename {fs => net}/9p/fcprint.c (64%)
>>   rename {fs => net}/9p/mux.c (55%)
>>
>>  even though is misses a lot of others (due to all the "v9fs" -> "p9"
>>  changes in the source code too - was that really worth it?).
>>
>>                          Linus
>>
>>  -------------------------------------------------------------------------
>>  This SF.net email is sponsored by DB2 Express
>>  Download DB2 Express C - the FREE version of DB2 express and take
>>  control of your XML. No limits. Just data. Click to get it now.
>>  http://sourceforge.net/powerbar/db2/
>>  _______________________________________________
>>  V9fs-developer mailing list
>>  V9fs-developer@lists.sourceforge.net
>>  https://lists.sourceforge.net/lists/listinfo/v9fs-developer
>> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
