Return-Path: <linux-kernel-owner+w=401wt.eu-S1753344AbYGJAYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbYGJAYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 20:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbYGJAYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 20:24:31 -0400
Received: from gw.goop.org ([64.81.55.164]:58604 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310AbYGJAY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 20:24:29 -0400
Message-ID: <487556A5.5090907@goop.org>
Date: Wed, 09 Jul 2008 17:24:05 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <48751CF9.4020901@linux-foundation.org>	<4875209D.8010603@goop.org> <48752CCD.30507@linux-foundation.org>	<m1wsjupuiz.fsf@frodo.ebiederm.org> <48753C99.5050408@goop.org> <m1ej62iq9z.fsf@frodo.ebiederm.org> <487555A8.2050007@zytor.com>
In-Reply-To: <487555A8.2050007@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Eric W. Biederman wrote:
>> Jeremy Fitzhardinge <jeremy@goop.org> writes:
>>
>>>> Which means that my idea of using the technique we use on x86_32 
>>>> will not
>>> work.
>>>
>>> No, the compiler memory model we use guarantees that everything will 
>>> be within
>>> 2G of each other.  The linker will spew loudly if that's not the case.
>>
>> The per cpu area is at least theoretically dynamically allocated.  
>> And we
>> really want to put it in cpu local memory.    Which means on any 
>> reasonable
>> NUMA machine the per cpu areas should be all over the box.
>>
>> So there is no guarantee that with an arbitrary 64bit address in %gs 
>> of anything.
>>
>
> That doesn't matter in the slightest.

Creepy, get out of my brain.

    J
