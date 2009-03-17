Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbZCQU15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbZCQU15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 16:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753051AbZCQU1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 16:27:48 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:28786 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbZCQU1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 16:27:47 -0400
Message-ID: <49C00787.6060401@oracle.com>
Date: Tue, 17 Mar 2009 13:26:47 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, mfasheh@suse.com
Subject: Re: Linux 2.6.28.8 (ocfs2 build failure)
References: <20090317012028.GA32410@kroah.com>
In-Reply-To: <20090317012028.GA32410@kroah.com>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.49C00707.0213:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable all possible OCFS2 kconfig options:



In file included from fs/ocfs2/alloc.c:42:
fs/ocfs2/journal.h: In function 'ocfs2_begin_ordered_truncate':
fs/ocfs2/journal.h:451: warning: passing argument 1 of 'jbd2_journal_begin_ordered_truncate' from incompatible pointer type
fs/ocfs2/journal.h:451: warning: passing argument 2 of 'jbd2_journal_begin_ordered_truncate' makes integer from pointer without a cast
fs/ocfs2/journal.h:451: error: too many arguments to function 'jbd2_journal_begin_ordered_truncate'
  CC [M]  fs/ocfs2/buffer_head_io.o
In file included from fs/ocfs2/aops.c:42:
fs/ocfs2/journal.h: In function 'ocfs2_begin_ordered_truncate':
fs/ocfs2/journal.h:451: warning: passing argument 1 of 'jbd2_journal_begin_ordered_truncate' from incompatible pointer type
fs/ocfs2/journal.h:451: warning: passing argument 2 of 'jbd2_journal_begin_ordered_truncate' makes integer from pointer without a cast
fs/ocfs2/journal.h:451: error: too many arguments to function 'jbd2_journal_begin_ordered_truncate'
make[2]: *** [fs/ocfs2/aops.o] Error 1
make[2]: *** Waiting for unfinished jobs....
In file included from fs/ocfs2/buffer_head_io.c:37:
fs/ocfs2/journal.h: In function 'ocfs2_begin_ordered_truncate':
fs/ocfs2/journal.h:451: warning: passing argument 1 of 'jbd2_journal_begin_ordered_truncate' from incompatible pointer type
fs/ocfs2/journal.h:451: warning: passing argument 2 of 'jbd2_journal_begin_ordered_truncate' makes integer from pointer without a cast
fs/ocfs2/journal.h:451: error: too many arguments to function 'jbd2_journal_begin_ordered_truncate'
make[2]: *** [fs/ocfs2/buffer_head_io.o] Error 1
make[2]: *** [fs/ocfs2/alloc.o] Error 1



-- 
~Randy
