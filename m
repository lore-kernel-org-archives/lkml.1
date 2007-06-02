Return-Path: <linux-kernel-owner+w=401wt.eu-S1757914AbXFBHdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914AbXFBHdQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 03:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbXFBHdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 03:33:04 -0400
Received: from il.qumranet.com ([82.166.9.18]:43249 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754710AbXFBHdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 03:33:02 -0400
Message-ID: <46611D2B.1060004@qumranet.com>
Date: Sat, 02 Jun 2007 10:32:59 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jun Koi <junkoi2004@gmail.com>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [GIT PULL][RESEND] KVM cpu hotplug fixes
References: <465FB8AA.6050504@qumranet.com>	 <alpine.LFD.0.98.0706010819050.3957@woody.linux-foundation.org>	 <46604A05.6060507@qumranet.com> <fdaac4d50706020003g5f1658fewf6e0757aaa1c27bd@mail.gmail.com>
In-Reply-To: <fdaac4d50706020003g5f1658fewf6e0757aaa1c27bd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Sat, 02 Jun 2007 10:32:59 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jun Koi wrote:
> Hi Avi,
>
> On 6/2/07, Avi Kivity <avi@qumranet.com> wrote:
>> Linus Torvalds wrote:
>> > Don't send me pull requests like this. And absolutely do NOT send
>> them as
>> > resends. I just  get grumpy.
>> >
>> > If all the added code had been KVM-only, I might not care. But when
>> the
>> > bulk of the code touches core files, you had better explain why
>> this is so
>> > important that it cannot wait for the next merge window.
>>
>> Ok.  This was really wanted by laptop-carrying users, but I guess
>> they'll have to wait for 2.6.23.
>>
>
> Could you explain a bit:
>
> 1) Why CPU hotplug is that important for virtualization?
>

It's not specifically important for virtualization.  It's a Linux kernel
feature, and right now it doesn't work very well when kvm is enabled,
and that should be fixed.


> 2) Why this patch is wanted by laptop users?

CPU hotplug is used by suspend/resume (basically, suspend hot-unplugs
all cpus except one an then suspends the machine.  Resume hotplugs the
cpus back after restarting the devices).

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

