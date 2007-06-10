Return-Path: <linux-kernel-owner+w=401wt.eu-S1757016AbXFJMXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016AbXFJMXG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 08:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbXFJMW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 08:22:56 -0400
Received: from il.qumranet.com ([82.166.9.18]:40235 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141AbXFJMWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 08:22:55 -0400
Message-ID: <466BED18.5040708@qumranet.com>
Date: Sun, 10 Jun 2007 15:22:48 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Luca <kronos.it@gmail.com>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [BUG] Oops with KVM-27
References: <20070603213432.GA3075@dreamland.darkstar.lan>	 <4663DCE9.3000107@qumranet.com>	 <20070604202248.GA18668@dreamland.darkstar.lan>	 <46647B3E.2090205@qumranet.com>	 <20070604212207.GA22365@dreamland.darkstar.lan>	 <46651069.5040003@qumranet.com> <68676e00706071216i4bd051c5hb1c114f3c13ab97f@mail.gmail.com>
In-Reply-To: <68676e00706071216i4bd051c5hb1c114f3c13ab97f@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Luca wrote:
> On 6/5/07, Avi Kivity <avi@qumranet.com> wrote:
>> Luca Tettamanti wrote:
>> > Il Mon, Jun 04, 2007 at 11:51:10PM +0300, Avi Kivity ha scritto:
>> >
>> >>> While doing repeated tests with the installer I ran into another
>> >>> (unrelated) problem. Sometimes the guest kernel hangs at boot at:
>> >>>
>> >>> NET: Registered protocol family 2
>> >>>
>> >>> with any kind of networking options (except for -net none, which 
>> works).
>> >>> With -no-kvm it boots with any networking option.
>> >>>
>> >>>
>> >>>
>> >> Can you try to pin the guest on a single core with taskset:
>> >>
>> >>    taskset 1 qemu ...
>> >>
>> >
>> > Doesn't help. What works is 'nolapic', i.e. disabling the local 
>> APIC on
>> > the guest kernel.
>> > I've also tried disabling TSC (notsc) and forcing PIT as the 
>> clocksource
>> > (clocksouce=pit clock=pit); neither of them helped.
>> >
>> >
>>
>> Is this a regression relative to a previous kvm version?
>
> Hello,
> sorry for the delay, I was having troubles compiling older KVMs with a
> recent kernel...
> The last version that works is kvm-21; starting from kvm-22 the VM
> hangs during network initialization (now always, but pretty often).
> This only occurs when the guest is Fedora7 setup ISO. The regular boot
> (i.e. from the hd) seems unaffected.

I've managed to reproduce this on kvm-21 (it takes many boots for this 
to happen, but it does eventually).

-- 
error compiling committee.c: too many arguments to function

