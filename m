Return-Path: <linux-kernel-owner+w=401wt.eu-S1755551AbZGHMq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbZGHMq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 08:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754886AbZGHMqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 08:46:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58227 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762AbZGHMqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 08:46:48 -0400
Message-ID: <4A549520.3010403@redhat.com>
Date: Wed, 08 Jul 2009 08:46:24 -0400
From: William Cohen <wcohen@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] add block IO documentation to tracepoint docbook
References: <4A4BBECD.8000908@redhat.com> <4A4C53EE.5000503@cn.fujitsu.com>
In-Reply-To: <4A4C53EE.5000503@cn.fujitsu.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> More CCed
> 
> William Cohen wrote:
>> The following patch adds block IO tracepoint documentation to the tracepoint
>> docbook.
>>
>> Signed-off-by: William Cohen <wcohen@xxxxxxxxxx>
> 
> Nice, thanks!
> 
> Acked-by: Li Zefan <lizf@cn.fujitsu.com>
> 
>> +/**
>> + * block_rq_abort - Abort Block Operation Request
> 
> Is it necessary to uppercase the first letter of every word?

I was assuming that it was a title. However, lower case would be okay.

-Will
> 
>> + * @q: queue containing the block operation request
>> + * @rq: block IO operation request
>> + *
>> + * Called immediately after pending block IO operation request @rq in
>> + * queue @q is aborted. The fields in the operation request @rq
>> + * can be examined to determine which device and sectors the pending
>> + * operation would access.
>> + */
>>  TRACE_EVENT(block_rq_abort,
>>  
>>  	TP_PROTO(struct request_queue *q, struct request *rq),
> 
> 

