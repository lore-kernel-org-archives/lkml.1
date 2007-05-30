Return-Path: <linux-kernel-owner+w=401wt.eu-S1753430AbXE3Il6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbXE3Il6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 04:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751362AbXE3Ilu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 04:41:50 -0400
Received: from pythagoras.zen.co.uk ([212.23.3.140]:48295 "EHLO
	pythagoras.zen.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbXE3Ilt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 04:41:49 -0400
Message-ID: <465D38CA.5050805@gmail.com>
Date: Wed, 30 May 2007 09:41:46 +0100
From: Matt Keenan <tank.en.mate@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH -mm] 1/2: MMCONFIG: validate against ACPI motherboard
 resources
References: <465CF794.1070406@shaw.ca> <alpine.LFD.0.98.0705292125511.26602@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705292125511.26602@woody.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-Pythagoras-IP: [82.69.27.224]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Tue, 29 May 2007, Robert Hancock wrote:
>   
>> This path adds validation of the MMCONFIG table against the ACPI reserved
>> motherboard resources.
>>     
>
> Please fix the formatting of your code.
>
>   
[snip snip]
> Same goes for this thing:
>
> +                       if((pci_probe & PCI_PROBE_CONF1) &&
> +                          e820_all_mapped(cfg->address,
> +                                          cfg->address + size - 1,
> +                                          E820_RESERVED))
> +                               printk(KERN_NOTICE "PCI: MCFG area at %Lx reserved in E820\n",
> +                                       cfg->address);
> +                       else
> +                               goto reject;
>
> there really is *not* a highly coveted prize for having the most different 
> indentation in the fewest possible lines of code!
>
>   

That looks like standard lisp style indenting (yes I realise that C != 
lisp).  At a guess I would say that code was written in emacs (which can 
be fixed by the necessary changes in your ~/.emacs). Grand parent post 
should check out these resources, they may help...

http://www.bloomington.in.us/~brutt/emacs-c-dev.html
http://lug.umbc.edu/tutorials/adv-emacs.html

or if you are really gung ho the CC-mode documentation

http://www.chemie.fu-berlin.de/chemnet/use/info/cc-mode/cc-mode_6.html

Matt
