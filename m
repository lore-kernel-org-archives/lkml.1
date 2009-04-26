Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbZDZOO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbZDZOO0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 10:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbZDZOOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 10:14:16 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:14240 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754108AbZDZOOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 10:14:15 -0400
Message-ID: <49F46C22.7020401@panasas.com>
Date: Sun, 26 Apr 2009 17:13:54 +0300
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1b3pre) Gecko/20090223 Thunderbird/3.0b2
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Fred Isaman <iisaman@citi.umich.edu>,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [PATCH] lib: find_last_bit.o needed by a module only, move it
 from lib to obj
References: <1240494032-9674-1-git-send-email-bhalevy@panasas.com> <200904262205.20608.rusty@rustcorp.com.au> <20090426131422.GA19701@infradead.org>
In-Reply-To: <20090426131422.GA19701@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Apr 2009 14:14:10.0284 (UTC) FILETIME=[44B53AC0:01C9C679]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr. 26, 2009, 16:14 +0300, Christoph Hellwig <hch@infradead.org> wrote:
> On Sun, Apr 26, 2009 at 10:05:19PM +0930, Rusty Russell wrote:
>> On Thu, 23 Apr 2009 11:10:32 pm Benny Halevy wrote:
>>> From: Fred Isaman <iisaman@citi.umich.edu>
>>>
>>> Currently, although find_last_bit is EXPORTed, it is statically linked with
>>> the lernel and is referenced only under CONFIG_SMP.
>> Acked-by: Rusty Russell <rusty@rustcorp.com.au>
>>
>> We know that any EXPORT_SYMBOL in lib-y is dubious, at least, but we're
>> lazy (ISTR it would gut lib-y to exclude them all).
> 
> The whole of lib-y is dangerous and we should just kill it..
> 

Why isn't it a standalone module?

Benny
