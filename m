Return-Path: <linux-kernel-owner+w=401wt.eu-S1760582AbYHDGcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760582AbYHDGcD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 02:32:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754783AbYHDGbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 02:31:53 -0400
Received: from qb-out-0506.google.com ([72.14.204.226]:64795 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717AbYHDGbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 02:31:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=FzJ/t2Ahg7sbT9/07WR58RnGPWykvUKzu+85WiWehGI25VV5GXIda2+pQe4puHadSD
         WX7hZMxLUwQVIW+XIEaeZ6RCYBT47fhs3RHVDTUHRTuUetHOAU6IxB1R84jsuItuf4jf
         SjpgldBh7ldb1mlBTfHwZ9U4aC6H1oBbGxRu0=
Message-ID: <4896A252.3000907@gmail.com>
Date: Mon, 04 Aug 2008 08:31:46 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>, Paul Menage <menage@google.com>,
       akpm@linux-foundation.org, Carl Henrik Lunde <chlunde@ping.uio.no>,
       axboe@kernel.dk, matt@bluehost.com, roberto@unbit.it,
       Marco Innocenti <m.innocenti@cineca.it>, randy.dunlap@oracle.com,
       Divyesh Shah <dpshah@google.com>, subrata@linux.vnet.ibm.com,
       eric.rannaud@gmail.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 2/3] i/o controller infrastructure
References: <> <1217801698-13438-3-git-send-email-righi.andrea@gmail.com> <489651E6.90001@cn.fujitsu.com>
In-Reply-To: <489651E6.90001@cn.fujitsu.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> Andrea Righi wrote:
>> This is the core io-throttle kernel infrastructure. It creates the basic
>> interfaces to cgroups and implements the I/O measurement and throttling
>> functions.
>>
>> Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
>> ---
>>  block/Makefile                |    2 ++
>>  include/linux/cgroup_subsys.h |    6 ++++++
>>  init/Kconfig                  |   10 ++++++++++
>>  3 files changed, 18 insertions(+), 0 deletions(-)
>>
> 
> where is block/blk-io-throttle.c and include/linux/blk-io-throttle.h?
> 

mmmh.. they should have been here, I mean, in patch 2/3 but it seems
they're gone in patch 1/3 (subject: i/o controller documentation):

Documentation of the block device I/O controller: description, usage,
advantages and design.

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 Documentation/controllers/io-throttle.txt |  312 +++++++++++++
 block/blk-io-throttle.c                   |  719 +++++++++++++++++++++++++++++
 include/linux/blk-io-throttle.h           |   41 ++
 3 files changed, 1072 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/controllers/io-throttle.txt
 create mode 100644 block/blk-io-throttle.c
 create mode 100644 include/linux/blk-io-throttle.h
...

I'm pretty sure I did a:
git-commit -s Documentation/controllers/io-throttle.txt
in my local branch (history confirms this), but, anyway, if you think
it's worth it I can fix it and post the patchset again, just let me
know.

Thanks for looking at it!
-Andrea
