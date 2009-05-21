Return-Path: <linux-kernel-owner+w=401wt.eu-S1753249AbZEUMha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbZEUMha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 08:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750904AbZEUMhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 08:37:22 -0400
Received: from vms173015pub.verizon.net ([206.46.173.15]:45802 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbZEUMhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 08:37:22 -0400
Message-id: <4A154AEF.506@acm.org>
Date: Thu, 21 May 2009 07:37:03 -0500
From: Corey Minyard <minyard@acm.org>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-version: 1.0
To: Ferenc Wagner <wferi@niif.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Openipmi-developer] modprobe ipmi_si hangs under 2.6.30-rc5
References: <87tz3qnh7o.fsf@tac.ki.iif.hu>
 <20090516170959.8057c9e4.akpm@linux-foundation.org>
 <877i0eqpss.fsf@tac.ki.iif.hu> <20090518184053.GA24134@minyard.local>
 <87iqjxzjz4.fsf@tac.ki.iif.hu> <4A1326C5.4010308@acm.org>
 <87ljoriwcw.fsf@tac.ki.iif.hu> <4A143103.9050302@acm.org>
 <878wkqpz2n.fsf@tac.ki.iif.hu>
In-reply-to: <878wkqpz2n.fsf@tac.ki.iif.hu>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ferenc Wagner wrote:
> Corey Minyard <minyard@acm.org> writes:
>
>   
>> Ferenc Wagner wrote:
>>
>>     
>>> Just out of interest, how often does the driver wake up to check
>>> the inteface?
>>>       
>> When idle, the driver wakes up every 10ms to check for something on
>> the driver.
>>     
>
> Wow, 100 times per second, that sure sounds gross for piping out SEL
> entries!  Though it certainly doesn't matter much for our servers, but
> hasn't it got the potential to heavily tax laptop batteries?  Or is
> that why ipmi_si isn't loaded automatically by udev?
>   
IPMI is used for a lot of things beyond just getting SEL entries.  I 
some cases (probably most) it's excessive, in others it's not.

However, AFAIK IPMI hardware is only available in server systems.  I 
don't think it's ever been used in a laptop.

-corey
