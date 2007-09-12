Return-Path: <linux-kernel-owner+w=401wt.eu-S934923AbXILRsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934923AbXILRsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 13:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933715AbXILRsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 13:48:16 -0400
Received: from smtpoutm.mac.com ([17.148.16.71]:60835 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933691AbXILRsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 13:48:15 -0400
In-Reply-To: <Pine.LNX.4.64.0709121034450.25084@localhost.localdomain>
References: <Pine.LNX.4.64.0709120339470.26177@localhost.localdomain> <46E7DEF8.50201@davidnewall.com> <Pine.LNX.4.64.0709120904130.20693@localhost.localdomain> <46E7F816.9080806@dawes.za.net> <Pine.LNX.4.64.0709121034450.25084@localhost.localdomain>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <3E869809-EA55-4F90-B364-788081ACEC00@mac.com>
Cc: Rogan Dawes <lists@dawes.za.net>, David Newall <david@davidnewall.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: stripping down the kernel-parameters.txt file
Date: Wed, 12 Sep 2007 13:47:38 -0400
To: "Robert P. J. Day" <rpjday@mindspring.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 12, 2007, at 10:44:29, Robert P. J. Day wrote:
> in the end, there should be a nice, *short* reference for what i  
> like to call "basic" kernel parms (defined by __setup() or  
> early_param()), while anyone who wants to learn about any module- 
> specific parms should then have to go look up the info for that  
> given module, that's all.
>
> as a trivial starting point, this would involve nothing more than  
> shifting current content around in kernel-parameters.txt, putting  
> the basic stuff at the top, and the module-specific stuff after  
> that.  heck, that would even give module authors the chance to add  
> a line or two of module description if they wanted.  how does life  
> get any better than that?

Well, maybe if modules could be used similarly to: "modprobe  
my_module --help" to give a description of the available module  
parameters.  That information might be merged into modules from text  
file(s) or vice-versa, but I can see it being significantly more  
useful.  Another mildly-useful feature would be to stick the basic  
boot params and those for built-in modules into a little text file  
which could optionally be embedded in the initramfs along with the  
"less" binary, so that a "vmlinuz --help" could be made to work  
usefully from your bootloader.

Cheers,
Kyle Moffett

