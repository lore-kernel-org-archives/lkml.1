Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886Ab0ARPUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab0ARPUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 10:20:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753668Ab0ARPUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 10:20:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664Ab0ARPUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 10:20:11 -0500
Message-ID: <4B547C09.8010906@redhat.com>
Date: Mon, 18 Jan 2010 17:19:37 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Gleb Natapov <gleb@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-api@vger.kernel.org, akpm@linux-foundation.org,
       andrew.c.morrow@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v6] add MAP_UNLOCKED mmap flag
References: <20100118133755.GG30698@redhat.com>	 <84144f021001180609r4d7fbbd0p972d5bc0e227d09a@mail.gmail.com>	 <20100118141938.GI30698@redhat.com>	 <20100118143232.0a0c4b4d@lxorguk.ukuu.org.uk>	 <1263826198.4283.600.camel@laptop>  <20100118150159.GB14345@redhat.com>	 <1263827194.4283.609.camel@laptop>  <4B547A31.4090106@redhat.com> <1263827683.4283.610.camel@laptop>
In-Reply-To: <1263827683.4283.610.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2010 05:14 PM, Peter Zijlstra wrote:
> On Mon, 2010-01-18 at 17:11 +0200, Avi Kivity wrote:
>    
>> On 01/18/2010 05:06 PM, Peter Zijlstra wrote:
>>      
>>> On Mon, 2010-01-18 at 17:01 +0200, Gleb Natapov wrote:
>>>
>>>        
>>>> There are valid uses for mlockall()
>>>>
>>>>          
>>> That's debatable.
>>>
>>>
>>>        
>> Real-time?
>>      
> I would not advice that, just mlock() the text and data you need for the
> real-time thread. mlockall() is a really blunt instrument.
>    

May not be feasible due to libraries.

-- 
error compiling committee.c: too many arguments to function

