Return-Path: <linux-kernel-owner+w=401wt.eu-S1752062AbZDNINk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbZDNINk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 04:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbZDNINX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 04:13:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53178 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbZDNINV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 04:13:21 -0400
Message-ID: <49E445CB.4030001@cn.fujitsu.com>
Date: Tue, 14 Apr 2009 16:14:03 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Theodore Ts'o" <tytso@mit.edu>, Shawn Du <duyuyang@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-btrace@vger.kernel.org
Subject: Re: PATCH 1/3] blktrace: support per-partition tracing
References: <49E42620.4050701@cn.fujitsu.com> <20090414075947.GA27003@elte.hu>
In-Reply-To: <20090414075947.GA27003@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> @@ -193,6 +194,7 @@ extern void __trace_note_message(struct blk_trace *, const char *fmt, ...);
>>  extern void blk_add_driver_data(struct request_queue *q, struct request *rq,
>>  				void *data, size_t len);
>>  extern int blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
>> +			   struct block_device *bdev,
>>  			   char __user *arg);
>>  extern int blk_trace_startstop(struct request_queue *q, int start);
>>  extern int blk_trace_remove(struct request_queue *q);
> 
> Small detail: you forgot about the !CONFIG_BLK_DEV_IO_TRACE case 
> here, the wrapper macros there need to be updated.
> 

Ah, sorry..

> (no need to resend - i fixed this up in the 1/3 and 3/3 patches)
> 

and thanks! (But I think only 1/3 patch needs to be fixed)

The 3rd patch can be for 2.6.30, if Ted or somene else wants to use
ftrace-plugin blktrace to trace dm devices in 2.6.30.

--
Zefan
