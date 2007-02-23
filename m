Return-Path: <linux-kernel-owner+w=401wt.eu-S932368AbXBWNum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368AbXBWNum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 08:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932374AbXBWNum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 08:50:42 -0500
Received: from mail.syneticon.net ([213.239.212.131]:60532 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932368AbXBWNul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 08:50:41 -0500
X-Greylist: delayed 1066 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Feb 2007 08:50:40 EST
Message-ID: <45DEECEE.6070108@wpkg.org>
Date: Fri, 23 Feb 2007 14:32:30 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Andrew Walrond <andrew@walrond.org>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: (Sparc64) 2.6.20 seems to ignore initramfs
References: <200702231108.10185.andrew@walrond.org>
In-Reply-To: <200702231108.10185.andrew@walrond.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Walrond schrieb:
> On a Sun T1000 I am trying to boot 2.6.20 using initramfs. (I use the same 
> procedure successfully on x86_64 and itanium2 servers).
> 
> The relevent silo section looks like this:
> 
> image=/boot/2.6.20.image
>         label=2.6.20
>         initrd=/boot/2.6.20.initramfs
>         partition=2
>         read-only
> 
> The kernel loads and boots and I see
> 

(...)

> 
> So it knows about the initramfs, but then tries to mount a root filesystem 
> instead...
> 
> I haven't tried this (initramfs)  with earlier kernels, so I don't know 
> whether this is a regression. Any clues about how to solve this would be 
> greatly appreciated.

Does it make a difference if you embed initramfs directly in the kernel?

CONFIG_INITRAMFS_SOURCE="/path/to/your/initramfs/directory"


-- 
Tomasz Chmielewski
http://wpkg.org

