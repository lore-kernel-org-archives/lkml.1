Return-Path: <linux-kernel-owner+w=401wt.eu-S1756045AbZCQVDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbZCQVDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 17:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbZCQVDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 17:03:25 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:42462 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbZCQVDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 17:03:25 -0400
Message-ID: <49C00FE9.9040407@oracle.com>
Date: Tue, 17 Mar 2009 14:02:33 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: tytso@mit.edu, Greg KH <gregkh@suse.de>, mfasheh@suse.com,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] Linux 2.6.28.8 (ocfs2 build failure)
References: <20090317012028.GA32410@kroah.com> <49C00787.6060401@oracle.com> <20090317205518.GA4442@kroah.com>
In-Reply-To: <20090317205518.GA4442@kroah.com>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.49C00F65.0271:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Tue, Mar 17, 2009 at 01:26:47PM -0700, Randy Dunlap wrote:
>> Enable all possible OCFS2 kconfig options:
>>
>>
>>
>> In file included from fs/ocfs2/alloc.c:42:
>> fs/ocfs2/journal.h: In function 'ocfs2_begin_ordered_truncate':
>> fs/ocfs2/journal.h:451: warning: passing argument 1 of 'jbd2_journal_begin_ordered_truncate' from incompatible pointer type
>> fs/ocfs2/journal.h:451: warning: passing argument 2 of 'jbd2_journal_begin_ordered_truncate' makes integer from pointer without a cast
>> fs/ocfs2/journal.h:451: error: too many arguments to function 'jbd2_journal_begin_ordered_truncate'
>>   CC [M]  fs/ocfs2/buffer_head_io.o
>> In file included from fs/ocfs2/aops.c:42:
>> fs/ocfs2/journal.h: In function 'ocfs2_begin_ordered_truncate':
>> fs/ocfs2/journal.h:451: warning: passing argument 1 of 'jbd2_journal_begin_ordered_truncate' from incompatible pointer type
>> fs/ocfs2/journal.h:451: warning: passing argument 2 of 'jbd2_journal_begin_ordered_truncate' makes integer from pointer without a cast
>> fs/ocfs2/journal.h:451: error: too many arguments to function 'jbd2_journal_begin_ordered_truncate'
>> make[2]: *** [fs/ocfs2/aops.o] Error 1
>> make[2]: *** Waiting for unfinished jobs....
>> In file included from fs/ocfs2/buffer_head_io.c:37:
>> fs/ocfs2/journal.h: In function 'ocfs2_begin_ordered_truncate':
>> fs/ocfs2/journal.h:451: warning: passing argument 1 of 'jbd2_journal_begin_ordered_truncate' from incompatible pointer type
>> fs/ocfs2/journal.h:451: warning: passing argument 2 of 'jbd2_journal_begin_ordered_truncate' makes integer from pointer without a cast
>> fs/ocfs2/journal.h:451: error: too many arguments to function 'jbd2_journal_begin_ordered_truncate'
>> make[2]: *** [fs/ocfs2/buffer_head_io.o] Error 1
>> make[2]: *** [fs/ocfs2/alloc.o] Error 1
> 
> Did this show up in 2.6.28.7?

no.

> Odds are it's one of the jbd2 patches from Ted.  Ted, any ideas?


-- 
~Randy
