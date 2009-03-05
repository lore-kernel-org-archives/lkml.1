Return-Path: <linux-kernel-owner+w=401wt.eu-S1756785AbZCEX6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbZCEX6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754251AbZCEX6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:58:32 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:52458 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbZCEX6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:58:31 -0500
Message-ID: <49B0674B.2000604@oracle.com>
Date: Thu, 05 Mar 2009 15:59:07 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Daniel Walker <dwalker@fifo99.com>
CC: Alan Stern <stern@rowland.harvard.edu>, Yinghai Lu <yinghai@kernel.org>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       ebiederm@xmission.com, akpm@linux-foundation.org, gregkh@suse.de,
       tglx@linutronix.de, sarah.a.sharp@intel.com, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/doc] x86/doc: mini-howto for using earlyprintk=dbgp
References: <Pine.LNX.4.44L0.0903051751330.2174-100000@iolanthe.rowland.org> <1236296921.5937.109.camel@desktop>
In-Reply-To: <1236296921.5937.109.camel@desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.49B066EB.0157:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:
> On Thu, 2009-03-05 at 17:54 -0500, Alan Stern wrote:
>> On Thu, 5 Mar 2009, Daniel Walker wrote:
>>
>>> Fix up some typos, and make the requirements section slightly cleaner.
>>>
>>> Signed-Off-By: Daniel Walker dwalker@fifo99.com
>>>
>>> diff --git a/Documentation/x86/earlyprintk.txt b/Documentation/x86/earlyprintk.txt
>>> index 607b1a0..5b51aef 100644
>>> --- a/Documentation/x86/earlyprintk.txt
>>> +++ b/Documentation/x86/earlyprintk.txt
>>> @@ -9,7 +9,9 @@ and two USB cables, connected like this:
>>>  
>>>  1. There are three specific hardware requirements:
>>>  
>>> - a.) Host/target system needs to have USB debug port capability.
>>> + a.) You will need two USB ports. One on the client/console system and one one the target system.
>> s/one one/one on/
>>
>> You might also try harder to observe the 80-column rule.
>>
>>> + 
>>> + b.) The client/console and target USB ports must have the debug port capability.
>>>  
>>>   You can check this capability by looking at a 'Debug port' bit in
>>>   the lspci -vvv output:
>>> @@ -35,15 +37,13 @@ and two USB cables, connected like this:
>>>  ( If your system does not list a debug port capability then you probably
>>>    wont be able to use the USB debug key. )
>>>  
>>> - b.) You also need a Netchip USB debug cable/key:
>>> + c.) You also need a Netchip USB debug cable/key:
>>>  
>>>          http://www.plxtech.com/products/NET2000/NET20DC/default.asp
>>>  
>>>       This is a small blue plastic connector with two USB connections,
>>>       it draws power from its USB connections.
>> No.  It draws power from one of its USB connections (the one on the 
>> right side when you're looking at the face with the PLX logo).
>>
>> Alan Stern
> 
> --
> 
> Fix up some typos, and make the requirements section slightly cleaner.
> Updated the power draw comment per Alan Stern.
> 
> Signed-Off-By: Daniel Walker <dwalker@fifo99.com>
> 
> diff --git a/Documentation/x86/earlyprintk.txt b/Documentation/x86/earlyprintk.txt
> index 607b1a0..ac913a6 100644
> --- a/Documentation/x86/earlyprintk.txt
> +++ b/Documentation/x86/earlyprintk.txt
> @@ -9,7 +9,11 @@ and two USB cables, connected like this:
>  
>  1. There are three specific hardware requirements:
>  
> - a.) Host/target system needs to have USB debug port capability.
> + a.) You will need two USB ports. One on the client/console system and one on 
> +     the target system.
> + 
> + b.) The client/console and target USB ports must have the debug port
> +     capability.

Is that correct on the (ugh, I think that the naming/terminology is
still mucked up, but you didn't do that) host/target system?

On the client/console (which I would call the host and I would call the
"Host/target" here just the Target system), a USB debug port is needed,
but on the Host/target, it should just look like a USB device.
At least that was the intent AFAIK/IIRC.  No?


-- 
~Randy
