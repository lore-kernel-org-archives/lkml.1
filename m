Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbYL3V3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbYL3V3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 16:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797AbYL3V3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 16:29:24 -0500
Received: from mail.lang.hm ([64.81.33.126]:60148 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768AbYL3V3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 16:29:23 -0500
Date: Tue, 30 Dec 2008 14:31:28 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: early exception error
In-Reply-To: <20081230212645.GA11696@localhost>
Message-ID: <alpine.DEB.1.10.0812301430390.16847@asgard.lang.hm>
References: <alpine.DEB.1.10.0812301416550.16847@asgard.lang.hm> <20081230212645.GA11696@localhost>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Dec 2008, Cyrill Gorcunov wrote:

> [david@lang.hm - Tue, Dec 30, 2008 at 02:21:10PM -0800]
>> I'm trying to upgrade a older dual opteron box to a current 64 bit
>> system, but I'm getting early exception errors from several different
>> kernels
>>
>> I tried the ubuntu 8.04 and 8.10 disks, and then I decided to try hunting
>> it down myself, so I took my 2.6.25 32 bit config copied it to a 64 bit
>> system and did a make oldconfig with 2.6.28 and am getting the same type
>> of error (the address changes from kernel to kernel and config to config
>> on the same kernel)
>>
>> doing a grep through System.map for the address that appears in the error
>> returns nothing
>>
>> attached are snapshots of the screen when the error happens and two
>> different configs with the same error (I tried disabling high-res timers,
>> tickless operation, and PAT, but got the same error), the 28 image is the
>> -2 config.
>>
>> where do I go from here to track this down?
>>
>> David Lang
> ...
>
> Hi David,
>
> not sure if it's the same but I've got similar errors for
> early_params being not capable to handle null passed args.
> What is the cmdline? It seems to be framebuffer related.
> But otoh I could be just wrong.

very trivial

grep -v "^#" /etc/lilo.conf
boot = /dev/sda
message = /boot/boot_message.txt
prompt
compact
timeout = 1200
change-rules
   reset
vga = ask
image = /boot/vmlinuz-2.6.28-64-2
   root = /dev/sda2
   label = 2.6.28-64

I trimmed the additional boot images from this.

David Lang
