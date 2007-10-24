Return-Path: <linux-kernel-owner+w=401wt.eu-S1750938AbXJXH4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750938AbXJXH4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 03:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbXJXH4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 03:56:06 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59074 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbXJXH4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 03:56:06 -0400
Message-ID: <471EFA90.2030402@garzik.org>
Date: Wed, 24 Oct 2007 03:56:00 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Paolo Ornati <ornati@fastwebnet.it>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>
Subject: Re: kvm_main.c:220: error: implicit declaration of function 'smp_call_function_mask'
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org> <20071024094427.31e3364a@localhost>
In-Reply-To: <20071024094427.31e3364a@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Ornati wrote:
>   CC      drivers/kvm/kvm_main.o
> drivers/kvm/kvm_main.c: In function 'kvm_flush_remote_tlbs':
> drivers/kvm/kvm_main.c:220: error: implicit declaration of function 'smp_call_function_mask'
> make[2]: *** [drivers/kvm/kvm_main.o] Error 1
> make[1]: *** [drivers/kvm] Error 2
> make: *** [drivers] Error 2
> 
> -----------
> 
> "smp_call_function_mask" is defined only on "CONFIG_SMP" but kvm uses it
> unconditionally, oops!

Yep, posted a build fix for this the other day...

	Jeff



