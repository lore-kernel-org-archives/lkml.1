Return-Path: <linux-kernel-owner+w=401wt.eu-S1763564AbXFEH1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763564AbXFEH1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 03:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761904AbXFEH1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 03:27:40 -0400
Received: from il.qumranet.com ([82.166.9.18]:49453 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761755AbXFEH1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 03:27:39 -0400
Message-ID: <46651069.5040003@qumranet.com>
Date: Tue, 05 Jun 2007 10:27:37 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Luca Tettamanti <kronos.it@gmail.com>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [BUG] Oops with KVM-27
References: <20070603213432.GA3075@dreamland.darkstar.lan> <4663DCE9.3000107@qumranet.com> <20070604202248.GA18668@dreamland.darkstar.lan> <46647B3E.2090205@qumranet.com> <20070604212207.GA22365@dreamland.darkstar.lan>
In-Reply-To: <20070604212207.GA22365@dreamland.darkstar.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Luca Tettamanti wrote:
> Il Mon, Jun 04, 2007 at 11:51:10PM +0300, Avi Kivity ha scritto: 
>   
>>> While doing repeated tests with the installer I ran into another
>>> (unrelated) problem. Sometimes the guest kernel hangs at boot at:
>>>
>>> NET: Registered protocol family 2
>>>
>>> with any kind of networking options (except for -net none, which works).
>>> With -no-kvm it boots with any networking option.
>>>
>>>   
>>>       
>> Can you try to pin the guest on a single core with taskset:
>>
>>    taskset 1 qemu ...
>>     
>
> Doesn't help. What works is 'nolapic', i.e. disabling the local APIC on
> the guest kernel.
> I've also tried disabling TSC (notsc) and forcing PIT as the clocksource
> (clocksouce=pit clock=pit); neither of them helped.
>
>   

Is this a regression relative to a previous kvm version?


-- 
error compiling committee.c: too many arguments to function

