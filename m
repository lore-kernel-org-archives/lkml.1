Return-Path: <linux-kernel-owner+w=401wt.eu-S1757373AbZCXIqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373AbZCXIqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 04:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbZCXIqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 04:46:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59990 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754737AbZCXIqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 04:46:02 -0400
Message-ID: <49C89DDF.3060509@cn.fujitsu.com>
Date: Tue, 24 Mar 2009 16:46:23 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] blktrace: print human-readable act_mask
References: <49C893FC.9080905@cn.fujitsu.com> <49C89488.4030604@cn.fujitsu.com> <20090324083956.GC13016@elte.hu>
In-Reply-To: <20090324083956.GC13016@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> Print stringified act_mask instead of hex value:
>>  # cat act_mask
>>  read,write,barrier,sync,queue,requeue,issue,complete,fs,pc,ahead,meta,
>>  discard,drv_data
>>  # echo "meta,write" > act_mask
>>  # cat act_mask
>>  write,meta
> 
> btw., does user-space blktrace make use of this facility?
> 

This facility can be used when we are using ftrace blktrace.

The userspace blktrace gets the filter-list via [-A hex-mask] and [-a str-mask].

like: blktrace -d /dev/sda -a write -a meta
