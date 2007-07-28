Return-Path: <linux-kernel-owner+w=401wt.eu-S935586AbXG1HVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935586AbXG1HVj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 03:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759190AbXG1HVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 03:21:30 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:57820 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759116AbXG1HV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 03:21:29 -0400
Message-ID: <46AAEDEB.7040003@gmail.com>
Date: Sat, 28 Jul 2007 09:19:07 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: david@lang.hm
CC: Daniel Hazelton <dhazelton@enter.net>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Frank Kingswood <frank@kingswood-consulting.co.uk>,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Ray Lee <ray-lk@madrabbit.org>, Jesper Juhl <jesper.juhl@gmail.com>,
       ck list <ck@vds.kolivas.org>, Paul Jackson <pj@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: RFT: updatedb "morning after" problem [was: Re: -mm merge plans
 for 2.6.23]
References: <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com> <20070727030040.0ea97ff7.akpm@linux-foundation.org> <1185531918.8799.17.camel@Homer.simpson.net> <200707271345.55187.dhazelton@enter.net> <46AA3680.4010508@gmail.com> <Pine.LNX.4.64.0707271239300.26221@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0707271239300.26221@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2007 09:43 PM, david@lang.hm wrote:

> On Fri, 27 Jul 2007, Rene Herman wrote:
> 
>> On 07/27/2007 07:45 PM, Daniel Hazelton wrote:
>>
>>>  Questions about it:
>>>  Q) Does swap-prefetch help with this?
>>>  A) [From all reports I've seen (*)]
>>>  Yes, it does. 
>>
>> No it does not. If updatedb filled memory to the point of causing 
>> swapping (which noone is reproducing anyway) it HAS FILLED MEMORY and 
>> swap-prefetch hasn't any memory to prefetch into -- updatedb itself 
>> doesn't use any significant memory.
> 
> however there are other programs which are known to take up significant 
> amounts of memory and will cause the issue being described (openoffice 
> for example)
> 
> please don't get hung up on the text 'updatedb' and accept that there 
> are programs that do run intermittently and do use a significant amount 
> of ram and then free it.

Different issue. One that's worth pursueing perhaps, but a different issue 
from the VFS caches issue that people have been trying to track down.

Rene.
