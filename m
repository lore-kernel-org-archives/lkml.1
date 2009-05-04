Return-Path: <linux-kernel-owner+w=401wt.eu-S1757290AbZEDPcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290AbZEDPcB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 11:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754591AbZEDPbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 11:31:51 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:32639 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479AbZEDPbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 11:31:51 -0400
Message-ID: <49FF0A16.904@oracle.com>
Date: Mon, 04 May 2009 08:30:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.28.10 (ocfs2 build failure)
References: <20090502200413.GA7287@kroah.com>
In-Reply-To: <20090502200413.GA7287@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt007.oracle.com [141.146.116.16]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.49FF09B6.002A,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> I'm announcing the release of the 2.6.28.10 kernel.
> 
> It contains a wide range of bugfixes, and all users of the 2.6.28 kernel
> series are strongly encouraged to upgrade.  Especially due to the CVE
> issues that are fixed here.
> 
> NOTE, this is the LAST update of the 2.6.28 kernel series, so all users
> are very strongly encouraged to upgrade to the 2.6.29 series at this
> point in time!

Sad.  It shouldn't end with build errors,


logs/ca-ostest292/kernel.make.log.i386.~2:fs/ocfs2/journal.h:451: error: too many arguments
 to function 'jbd2_journal_begin_ordered_truncate'
logs/ca-ostest292/kernel.make.log.i386.~2:make[2]: *** [fs/ocfs2/alloc.o] Error 1
logs/ca-ostest292/kernel.make.log.i386.~2:fs/ocfs2/journal.h:451: error: too many arguments
 to function 'jbd2_journal_begin_ordered_truncate'
logs/ca-ostest292/kernel.make.log.i386.~2:make[2]: *** [fs/ocfs2/aops.o] Error 1
logs/ca-ostest292/kernel.make.log.i386.~2:fs/ocfs2/journal.h:451: error: too many arguments
 to function 'jbd2_journal_begin_ordered_truncate'
logs/ca-ostest292/kernel.make.log.i386.~2:make[2]: *** [fs/ocfs2/buffer_head_io.o] Error 1
logs/ca-ostest292/kernel.make.log.i386.~2:fs/ocfs2/journal.h:451: error: too many arguments
 to function 'jbd2_journal_begin_ordered_truncate'
logs/ca-ostest292/kernel.make.log.i386.~2:make[2]: *** [fs/ocfs2/dir.o] Error 1
[truncated]



-- 
~Randy
