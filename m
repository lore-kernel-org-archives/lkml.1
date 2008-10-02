Return-Path: <linux-kernel-owner+w=401wt.eu-S1753032AbYJBJGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbYJBJGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 05:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbYJBJFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 05:05:53 -0400
Received: from lirone.symas.net ([64.71.152.235]:52674 "EHLO lirone.symas.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbYJBJFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 05:05:52 -0400
Message-ID: <48E48EE9.9090900@symas.com>
Date: Thu, 02 Oct 2008 02:05:45 -0700
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; rv:1.9.1b1pre) Gecko/20080917130338 SeaMonkey/2.0a1pre
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: APIC frequency too slow on HP dv5z
References: <48E28443.7060708@symas.com> <alpine.LFD.1.10.0810021052410.5549@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0810021052410.5549@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Tue, 30 Sep 2008, Howard Chu wrote:
>
>> More often than not, on a warm boot I see something like this
>>
>> msg.new:[    1.940031] Using local APIC timer interrupts.
>> msg.new:[    1.944031] APIC timer calibration result 466046
>> msg.new:[    1.944031] Detected 0.466 MHz APIC timer.
>> msg.new:[    1.944031] APIC frequency too slow, disabling apic timer
>>
>> On cold boots it may see 12.5MHz, or may not...
>>
>> [    2.000584] Using local APIC timer interrupts.
>> [    2.004067] APIC timer calibration result 12500236
>> [    2.004080] Detected 12.500 MHz APIC timer.
>>
>> I haven't figured out yet what the pattern is behind the behavior. Has anyone
>> else seen this kind of problem before?
>
> Hmm, strange. Which kernel version ?

I only started paying attention recently. 2.6.27-rc4 thru rc7 for sure. I'm 
running rc7 right now, that's what those log snippets are from.

-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
