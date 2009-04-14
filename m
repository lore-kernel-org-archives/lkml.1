Return-Path: <linux-kernel-owner+w=401wt.eu-S1755179AbZDNMjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbZDNMjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 08:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114AbZDNMjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 08:39:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52147 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988AbZDNMjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 08:39:07 -0400
Message-ID: <49E4840E.6010300@redhat.com>
Date: Tue, 14 Apr 2009 15:39:42 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ed Tomlinson <edt@aei.ca>
CC: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.30-rc1 A few issues and a stall
References: <200904121124.07193.edt@aei.ca> <49E45F8E.9080803@redhat.com> <200904140832.25057.edt@aei.ca>
In-Reply-To: <200904140832.25057.edt@aei.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ed Tomlinson wrote:
> On Tuesday 14 April 2009 06:03:58 Avi Kivity wrote:
>   
>> Ed Tomlinson wrote:
>>     
>>> Once the above networking stuff is setup I start kvm with the command below
>>>
>>> QEMU_AUDIO_DRV=alsa kvm -m 1024 -cdrom /mnt/sdc4/divx/archlinux-2009.02-ftp-i686.iso -boot c -smp 3 -usb -usbdevice tablet -vga std -drive file=arch.img -net nic,macaddr=52:54:00:12:34:23 -net tap,ifname=qtap0,script=no -soundhw all -mem-path /hugepages
>>>
>>> which works and the kvm session boots just fine.  
>>>
>>> Issue 2.  When I attempt to ping outside the kvm session the pc (not just the kvm session) hangs.
>>> Its impossible to kill the kvm session and there are numerious info messages from RCU (tree RCU enabled)
>>> about stalls.  
>>>   
>>>       
>> The rcu messages are likely because a processor has died.
>>
>> Do things work if you drop -mem-path?
>>     
>
> It makes no difference.  I did notice that one cpu is peged at 100% though.  I'll be trying
> CONFIG_PROVE_LOCKING tonight for another problem - might give interesting results.
>   

Oh, so this goes away without CONFIG_PROVE_LOCKING?

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

