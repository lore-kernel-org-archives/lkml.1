Return-Path: <linux-kernel-owner+w=401wt.eu-S1764045AbXKJENV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764045AbXKJENV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 23:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755271AbXKJENN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 23:13:13 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:43402 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181AbXKJENM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 23:13:12 -0500
Message-ID: <47352FC9.9080701@garzik.org>
Date: Fri, 09 Nov 2007 23:12:57 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Brian Gerst <bgerst@didntduck.org>
CC: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/11 v3] enable "make ARCH=x86"
References: <20071109230812.GA5176@uranus.ravnborg.org> <4735242B.1010801@garzik.org> <47352DF2.5000409@didntduck.org>
In-Reply-To: <47352DF2.5000409@didntduck.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Gerst wrote:
> Jeff Garzik wrote:
>> Sam Ravnborg wrote:
>>> This is the patch that get rid of ARCH=i386 and ARCH=x86_64
>>> and introduce ARCH=x86.
>>> It touches several files but the changes are all one or two-liners.
>>>
>>>       x86: drop backward compatibility symlinks to i386/boot and
>>> x86_64/boot
>>>       kbuild: sanity check the specified arch
>>
>> IMO it negatives impacts the workflow when you -remove- the ability to
>> set 32/64-bit on the make command line.
>>
>> Building and testing for both architectures now requires the additional
>> step of editing .config, which is a clear workflow negative impact at
>> least for me.
>>
>> I switch between other cross-compiled arches (alpha, usually) on the
>> makefile command line
>>
>> Yes, I know other 32/64-bit arches require .config editing.  That
>> doesn't change the basic fact that this is a workflow regression.
>>
>>     Jeff
> 
> You can use:
> 
> make i386_defconfig
> make x86_64_defconfig

Does that work for alpha too?


> In any other case you'd be editing the .config anyways.

No, that's a logic rathole down which I will not follow :)

You can make any argument along those lines command line usage is really 
an art, not a science.  Its a user interface, and that involves human 
taste rather than logic.

I've been bouncing between architectures using ARCH= for years, and my 
fingers and brain have been trained.  It's just disappointing and a pain 
to change this nice user interface that has served so well for years.

This is /not/ a cleanup, it's a user interface change.

	Jeff



