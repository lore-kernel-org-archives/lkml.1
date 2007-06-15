Return-Path: <linux-kernel-owner+w=401wt.eu-S1755415AbXFOPsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbXFOPsP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 11:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751047AbXFOPsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 11:48:00 -0400
Received: from smtp-03.mandic.com.br ([200.225.81.143]:57161 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbXFOPsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 11:48:00 -0400
Message-ID: <4672B4A6.8020909@mandic.com.br>
Date: Fri, 15 Jun 2007 12:47:50 -0300
From: "Renato S. Yamane" <renatoyamane@mandic.com.br>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: =?UTF-8?B?TWloYWkgRG9uyJt1?= <mihai.dontu@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Linux Servers comparison with Windows 2003 servers for Gaming
References: <8d6898730706150712u182f5af1h2d92030adf16d022@mail.gmail.com> <20070615152313.3638b4d5@the-village.bc.nu> <4672A3AA.6010705@mandic.com.br> <200706151753.14721.mihai.dontu@gmail.com>
In-Reply-To: <200706151753.14721.mihai.dontu@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mihai Donțu wrote:
> On Friday 15 June 2007 17:35, you wrote:
>> E.g. I have a laptop Toshiba M45-S355 (with ReiserFS) and don't have 
>> experience to choose what I can remove from kernel (or compile as 
>> module/built-in).
> 
>   Well, here are some steps:
>   1. boot an Ubuntu livecd
>   2. lspci && lsmod and see what it has detected/loaded
>   3. cd /usr/src/linux && make menuconfig
>   4. read the help for each "set" option and see what it does (like many
> people did in the early days). If you don't find it useful, press N.

One more detail: Is better put this modules listed in lsmod as "built-in"?

One doubt, in my lsmod I see sd_mod, cdrom, intel_agp, sg, pcmci_core, 
agppart, snd_page_alloc, and some others, but they didn't listed in 
.config file

E.g.
#cat config_2.6.21.1.txt | grep -i sd_mod
Result is empty!

Best regards,
Renato
