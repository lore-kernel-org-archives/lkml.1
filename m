Return-Path: <linux-kernel-owner+w=401wt.eu-S1752958AbXJULXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbXJULXQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 07:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbXJULXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 07:23:05 -0400
Received: from il.qumranet.com ([82.166.9.18]:44218 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbXJULXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 07:23:04 -0400
Message-ID: <471B366B.7040706@qumranet.com>
Date: Sun, 21 Oct 2007 13:22:19 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Bart Trojanowski <bart@jukie.net>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [BUG] 2.6.23.1 host freezes when running kvm
References: <20071019202019.GW3962@jukie.net> <20071020000240.GX3962@jukie.net> <20071020154445.GA5254@jukie.net>
In-Reply-To: <20071020154445.GA5254@jukie.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Trojanowski wrote:
> * Bart Trojanowski <bart@jukie.net> [071019 20:03]:
>   
>> * Bart Trojanowski <bart@jukie.net> [071019 17:00]:
>> <snip>
>>     
>>> Once the system is booted, I attached using vnc, then I ssh in and ran
>>> 'svn update'... and the host machine froze.
>>>
>>> The last messages I on my serial console are:
>>>
>>> kvm: unhandled rdmsr: 0x417
>>> kvm: unhandled rdmsr: 0xc0000400
>>>       
>> <snip>
>>     
>>> I noticed that linus merged a bunch of KVM changes last week.  I will
>>> try those out next.
>>>       
>> It looks like Linus' tree has the fix already.
>>     
>
> I spoke too soon.  The latest from Linus' tree also freezes... but it
> took overnight to get there.  There was no particular load on it.
>
> This system was previously running 2.6.22.y w/o problems with a similar
> kvm pattern.
>
> This time it froze w/o showing any kvm rdmsr messages.  And while it
> froze sometime over night, I cannot be sure when.  Here is the SysRq's
> "showPc" output:
>   

Does 2.6.23 hang immediately?  If so, these may be two separate problems 
and it's worth bisecting to find out what's the fix in 2.6.24-rc.

Of course we'll have to address the later hang as well.


-- 
error compiling committee.c: too many arguments to function

