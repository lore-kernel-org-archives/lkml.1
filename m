Return-Path: <linux-kernel-owner+w=401wt.eu-S1752988Ab0AZU71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab0AZU71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 15:59:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640Ab0AZU70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 15:59:26 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:50437 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab0AZU7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 15:59:25 -0500
Message-ID: <4B5F5794.8020302@cs.helsinki.fi>
Date: Tue, 26 Jan 2010 22:59:00 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Nigel Cunningham <ncunningham@crca.org.au>,
       Pedro Ribeiro <pedrib@gmail.com>, linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>,
       "linux-mm@kvack.org >> linux-mm" <linux-mm@kvack.org>
Subject: Re: BUG at mm/slab.c:2990 with 2.6.33-rc5-tuxonice
References: <74fd948d1001261121r7e6d03a4i75ce40705abed4e0@mail.gmail.com>	 <4B5F52FE.5000201@crca.org.au> <1264539045.3536.1348.camel@calx>
In-Reply-To: <1264539045.3536.1348.camel@calx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Wed, 2010-01-27 at 07:39 +1100, Nigel Cunningham wrote:
>> Hi.
>>
>> Pedro Ribeiro wrote:
>>> Hi,
>>>
>>> I hit a bug at mm/slab.c:2990 with .33-rc5.
>>> Unfortunately nothing more is available than a screen picture with a
>>> crash dump, although it is a good one.
>>> The bug was hit almost at the end of a hibernation cycle with
>>> Tux-on-Ice, while saving memory contents to an encrypted swap
>>> partition.
>>>
>>> The image is here http://img264.imageshack.us/img264/9634/mmslab.jpg (150 kb)
>>>
>>> Hopefully it is of any use for you. Please let me know if you need any
>>> more info.
>> Looks to me to be completely unrelated to TuxOnIce - at least at a first
>> glance.
>>
>> Ccing the slab allocator maintainers listed in MAINTAINERS.
> 
> Not sure if this will do us any good, it's the second oops.

Looks like slab corruption to me which is usually not a slab bug but 
caused by buggy callers. Is CONFIG_DEBUG_SLAB enabled?
