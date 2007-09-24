Return-Path: <linux-kernel-owner+w=401wt.eu-S1762549AbXIXSYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762549AbXIXSYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 14:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757799AbXIXSYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 14:24:46 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:44624 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756040AbXIXSYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 14:24:45 -0400
Message-ID: <46F800A7.7090005@oracle.com>
Date: Mon, 24 Sep 2007 11:23:35 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [patch 6/7] Linux Kernel Markers - Documentation
References: <20070924164950.006047409@polymtl.ca> <20070924165428.335030720@polymtl.ca> <20070924175044.GD1608@infradead.org> <20070924105632.009aba7f.randy.dunlap@oracle.com> <20070924180041.GB2435@infradead.org> <20070924111318.f16cde07.randy.dunlap@oracle.com> <20070924181931.GA3810@infradead.org>
In-Reply-To: <20070924181931.GA3810@infradead.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, Sep 24, 2007 at 11:13:18AM -0700, Randy Dunlap wrote:
>>  Documentation/trace/src/Makefile     |    7 +
>>  Documentation/trace/src/README       |   18 +
>>  Documentation/trace/src/fork_trace.c |  119 +++++++
>>  Documentation/trace/trace.txt        |  164 ++++++++++
>>  include/linux/trace.h                |   99 ++++++
>>  lib/Kconfig                          |    9 +
>>  lib/Makefile                         |    2 +
>>  lib/trace.c                          |  563 +++++++++++++++++++++++++++
>> +++++++
>>  8 files changed, 981 insertions(+), 0 deletions(-)
>>
>>
>> All of the trace/src/ subdirectory?
> 
> Yes, but only as a single file.  We don't really want READMES in source
> directories.  Instead these 18 lines would do a perfect comment on the
> top of the file.

That might be OK for this case, but sometimes it makes sense to have
README etc. about how to use the software.  So you would want this
in the Documentation/ tree?  That makes it harder on users.

-- 
~Randy
Phaedrus says that Quality is about caring.
