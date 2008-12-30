Return-Path: <linux-kernel-owner+w=401wt.eu-S1754138AbYL3Vl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbYL3Vl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 16:41:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753593AbYL3Vlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 16:41:46 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:1876 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955AbYL3Vlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 16:41:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QwvNvSGWXHRytqVL9eQcrRcWoJONcuH8Hls68FegxE4a1T8rWR7DuyZv3GyND0j7rb
         gx0TrVEwgUFQSd9+U7HVV/cPaAG30zKiv7hBFfTVtw+N7ZCTG1WfW+GQbRideQpnMQGI
         UwROqAp1VlzGqAWx/9Bhp8+nJHNpfAMuYTzN4=
Date: Wed, 31 Dec 2008 00:41:43 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: david@lang.hm
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: early exception error
Message-ID: <20081230214143.GB11696@localhost>
References: <alpine.DEB.1.10.0812301416550.16847@asgard.lang.hm> <20081230212645.GA11696@localhost> <alpine.DEB.1.10.0812301430390.16847@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0812301430390.16847@asgard.lang.hm>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[david@lang.hm - Tue, Dec 30, 2008 at 02:31:28PM -0800]
> On Wed, 31 Dec 2008, Cyrill Gorcunov wrote:
>
>> [david@lang.hm - Tue, Dec 30, 2008 at 02:21:10PM -0800]
>>> I'm trying to upgrade a older dual opteron box to a current 64 bit
>>> system, but I'm getting early exception errors from several different
>>> kernels
>>>
>>> I tried the ubuntu 8.04 and 8.10 disks, and then I decided to try hunting
>>> it down myself, so I took my 2.6.25 32 bit config copied it to a 64 bit
>>> system and did a make oldconfig with 2.6.28 and am getting the same type
>>> of error (the address changes from kernel to kernel and config to config
>>> on the same kernel)
>>>
>>> doing a grep through System.map for the address that appears in the error
>>> returns nothing
>>>
>>> attached are snapshots of the screen when the error happens and two
>>> different configs with the same error (I tried disabling high-res timers,
>>> tickless operation, and PAT, but got the same error), the 28 image is the
>>> -2 config.
>>>
>>> where do I go from here to track this down?
>>>
>>> David Lang
>> ...
>>
>> Hi David,
>>
>> not sure if it's the same but I've got similar errors for
>> early_params being not capable to handle null passed args.
>> What is the cmdline? It seems to be framebuffer related.
>> But otoh I could be just wrong.
>
> very trivial
>
> grep -v "^#" /etc/lilo.conf
> boot = /dev/sda
> message = /boot/boot_message.txt
> prompt
> compact
> timeout = 1200
> change-rules
>   reset
> vga = ask
> image = /boot/vmlinuz-2.6.28-64-2
>   root = /dev/sda2
>   label = 2.6.28-64
>
> I trimmed the additional boot images from this.
>
> David Lang
>

thanks David, will try to reproduce it

		- Cyrill -
