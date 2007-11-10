Return-Path: <linux-kernel-owner+w=401wt.eu-S1761892AbXKJEGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761892AbXKJEGB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 23:06:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763711AbXKJEFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 23:05:52 -0500
Received: from quark.didntduck.org ([69.55.226.66]:33233 "EHLO
	quark.didntduck.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbXKJEFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 23:05:51 -0500
Message-ID: <47352DF2.5000409@didntduck.org>
Date: Fri, 09 Nov 2007 23:05:06 -0500
From: Brian Gerst <bgerst@didntduck.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070926)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/11 v3] enable "make ARCH=x86"
References: <20071109230812.GA5176@uranus.ravnborg.org> <4735242B.1010801@garzik.org>
In-Reply-To: <4735242B.1010801@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Sam Ravnborg wrote:
>> This is the patch that get rid of ARCH=i386 and ARCH=x86_64
>> and introduce ARCH=x86.
>> It touches several files but the changes are all one or two-liners.
>>
>>       x86: drop backward compatibility symlinks to i386/boot and
>> x86_64/boot
>>       kbuild: sanity check the specified arch
> 
> 
> IMO it negatives impacts the workflow when you -remove- the ability to
> set 32/64-bit on the make command line.
> 
> Building and testing for both architectures now requires the additional
> step of editing .config, which is a clear workflow negative impact at
> least for me.
> 
> I switch between other cross-compiled arches (alpha, usually) on the
> makefile command line
> 
> Yes, I know other 32/64-bit arches require .config editing.  That
> doesn't change the basic fact that this is a workflow regression.
> 
>     Jeff

You can use:

make i386_defconfig
make x86_64_defconfig

In any other case you'd be editing the .config anyways.

--
				Brian Gerst
