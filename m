Return-Path: <linux-kernel-owner+w=401wt.eu-S1758084AbZKRRnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084AbZKRRnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 12:43:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758064AbZKRRnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 12:43:13 -0500
Received: from relay2.sgi.com ([192.48.179.30]:45809 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758061AbZKRRnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 12:43:12 -0500
Message-ID: <4B043232.50907@sgi.com>
Date: Wed, 18 Nov 2009 09:43:14 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] x86: Limit the number of processor bootup messages
References: <20091117191752.164451000@alcatraz.americas.sgi.com>	 <20091117191757.651569000@alcatraz.americas.sgi.com>	 <86802c440911171210x4780c08cg3b3260afd5d2bc5d@mail.gmail.com>	 <4B030799.9020402@zytor.com> <86802c440911171311s1313abf5h4059422b1214ec75@mail.gmail.com>
In-Reply-To: <86802c440911171311s1313abf5h4059422b1214ec75@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Yinghai Lu wrote:
> On Tue, Nov 17, 2009 at 12:29 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 11/17/2009 12:10 PM, Yinghai Lu wrote:
>>>> The following lines have been removed:
>>>>
>>>>        CPU: Physical Processor ID:
>>>>        CPU: Processor Core ID:
>>>>        CPU %d/0x%x -> Node %d
>>> please don't.
>>>
>> Why not?
>>
>> Or, more formally: please state the rationale for keeping them.
>>
> at least one distribution: SLES 11 mess it up when BSP is from socket
> 1 instead of socket0
> 
> and above message does show kernel think BSP still from socket0, and
> other cores in that package are from socket1.

[    1.601924] Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 Ok.

How does one imply Socket 1 from Node 0?

I added the socket and core id for BSP.  I think cluttering up output
with useless additional information that is easily available is not
worthwhile.
