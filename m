Return-Path: <linux-kernel-owner+w=401wt.eu-S1754948AbZETNb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948AbZETNb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 09:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbZETNbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 09:31:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:59417 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbZETNbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 09:31:51 -0400
Cc: Li Yang <leoli@freescale.com>, Wolfgang Denk <wd@denx.de>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       LKML List <linux-kernel@vger.kernel.org>
Message-Id: <156C2E1E-8E67-4358-B72E-4BB67D79C2AF@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Scott Wood <scottwood@freescale.com>
In-Reply-To: <20090513194249.BA7D9832E416@gemini.denx.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH] [PowerPC] MPC8272ADS: fix device tree for 8 MB flash size
Date: Wed, 20 May 2009 08:29:30 -0500
References: <1242155174-2513-1-git-send-email-wd@denx.de> <2a27d3730905130328m27743852w2d68a62ebc32ce31@mail.gmail.com> <20090513194249.BA7D9832E416@gemini.denx.de>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 13, 2009, at 2:42 PM, Wolfgang Denk wrote:

> Dear Li Yang,
>
> In message <2a27d3730905130328m27743852w2d68a62ebc32ce31@mail.gmail.com 
> > you wrote:
>>
>> Although 8MB seems to be the common size used.  It can be very easy
>> changed as a pluggable module.  It might be better to make the code
>> working for any reasonable flash sizes.
>
> You either have to provide a correct device tree for your board, or
> use a boot loader / boot wrapper that fixes the flash base address and
> size.
>
> At the moment, U-Boot does not  contain  any  code  yet  to  do  that
> (patches  welcome :-), and as far as I understand the cuImage wrapper
> works just the other way  round:  it  adjusts  the  mappings  to  the
> settings  in  the  device tree, which may or may not match the actual
> hardware. This may work, but at least gives  you  a  different  flash
> memory  map  in Linux than what you had before in U-Boot, so it's not
> really nice either.
>
>
> Hm... it seems the majority of MPC8272ADS boards seems to come indeed
> with 8 MB NOR flash, so I wonder if the patch should actually go in?
>
> Best regards,
>
> Wolfgang Denk

Scott, any feedback if our boards have 8M or 32M flash modules?

- k
