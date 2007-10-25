Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbXJYWEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbXJYWEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 18:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbXJYWEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 18:04:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36456 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbXJYWEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 18:04:44 -0400
Message-ID: <472112EA.3020604@zytor.com>
Date: Thu, 25 Oct 2007 15:04:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Michael Lothian <mike@fireburn.co.uk>,
       Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: Possibility of adding -march=native to x86
References: <0EC33A59AA72084CA28B83816B40929F02682BB3@REEDXCLSXM01V03.rbsres01.net> <fc94aae90710251133j4bada173h6298242ece586b61@mail.gmail.com> <20071025185022.GP30533@stusta.de> <fc94aae90710251209n74e2cffbj2e3cdd321f36da0d@mail.gmail.com> <20071025191723.GQ30533@stusta.de> <fc94aae90710251232m117421e7ref3e5a6270ff25d2@mail.gmail.com> <20071025195020.GS30533@stusta.de> <fc94aae90710251312w2eba46e8h5d4f8715ad0e91b6@mail.gmail.com> <4720FF2B.9020802@googlemail.com> <fc94aae90710251430s669418e5v72282ff5f8a5691e@mail.gmail.com> <20071025214647.GX30533@stusta.de>
In-Reply-To: <20071025214647.GX30533@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
>>>
>> Yes for something like a distro kernel it is bad but as I said before
>> this isn't what this is for.
>>
>> Eventually it would be nice to to a make localkernel and for a
>> customised kernel to be build compiling in all pci / pci express
>> drivers into the kernel and all usb devices as modules.
>>
>> Auto magically detecting the cpu would be part of that
>>
>> I hate getting a new piece of kit and then have to figure out from
>> lspci which options need to be turned on and the the really iritation
>> part of finding the option in make menuconfig
> 
> What exactly is irritating?
> Please name the problems so that they can be fixed.
> 
>> Detecting the cpu and using march=native could be all part of that
> 
> You don't need march=native for this.
> 
> You have to set the right config option for your CPU and you 
> automatically get the right compiler options.
> 

There was a long discussion years ago -- the infamous "Aunt Tillie" 
thread -- about automatically configuring customized kernels for 
specific hardware.

It's somewhat of an unusual thing to bother with these days, except for 
people who develop and maintain the kernel.

	-hpa
