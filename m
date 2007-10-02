Return-Path: <linux-kernel-owner+w=401wt.eu-S1755336AbXJBRqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbXJBRqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 13:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbXJBRq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 13:46:26 -0400
Received: from atlrel8.hp.com ([156.153.255.206]:41309 "EHLO atlrel8.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119AbXJBRqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 13:46:24 -0400
Message-ID: <4702851A.1050100@hp.com>
Date: Tue, 02 Oct 2007 13:51:22 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       btrace <linux-btrace@vger.kernel.org>
Subject: Re: Linux Kernel Markers - performance characterization with large
 IO load on large-ish system
References: <46F92219.9020406@hp.com> <20070925171349.GA6057@Krystal> <46FA7A86.6090804@hp.com> <20071002122118.GL5236@kernel.dk> <20071002124803.GA23425@Krystal>
In-Reply-To: <20071002124803.GA23425@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
>> remember that we have seen and discussed something like this before,
>> it's still a puzzle to me...
>>
>>     
> I do wonder about that performance _increase_ with blktrace enabled. I
>
> Interesting question indeed.
>
> In those tests, when blktrace is running, are the relay buffers only
> written to or they are also read ?
>   

blktrace (the utility) was running too - so the relay buffere /were/
being read and stored out to disk elsewhere.

> Running the tests without consuming the buffers (in overwrite mode)
> would tell us more about the nature of the disturbance causing the
> performance increase.
>   

I'd have to write a utility to enable the traces, but then not read. Let
me think about that.

> Also, a kernel trace could help us understand more thoroughly what is
> happening there.. is it caused by the scheduler ? memory allocation ?
> data cache alignment ?
>   

Yep - when I get some time, I'll look into that. [Clearly not a gating
issue for marker support...]

> I would suggest that you try aligning the block layer data structures
> accessed by blktrace on L2 cacheline size and compare the results (when
> blktrace is disabled).
>   

Again, when I get some time! :-)

Alan
