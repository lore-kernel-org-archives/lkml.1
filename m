Return-Path: <linux-kernel-owner+w=401wt.eu-S1161306AbXBGNvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161306AbXBGNvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 08:51:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161309AbXBGNvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 08:51:31 -0500
Received: from wx-out-0506.google.com ([66.249.82.239]:8581 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161306AbXBGNva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 08:51:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Y/50tFSjqpd/BlicxrudWLJtGSDR5MsSfU/Ouwc0rxZCcueXHURmSzIpWDrf6uhPU16W/nMI27Lg4w6qKDzT9gAyCbjqTnzQ28B06iFg3eWO7YOG7UMYLFdlDxWDU+ouygXOkDB7+cT+ySvAdxxQL7AIZEOVJ3Id3QdmLsOj6cg=
Message-ID: <8355959a0702070551m2275f235wa230691663aa91ae@mail.gmail.com>
Date: Wed, 7 Feb 2007 19:21:28 +0530
From: "Sunil Naidu" <akula2.shark@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
Cc: "David Woodhouse" <dwmw2@infradead.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0702061615480.8424@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1170801484.29759.1000.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0702061451560.8424@woody.linux-foundation.org>
	 <1170803515.29759.1032.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0702061516110.8424@woody.linux-foundation.org>
	 <1170804983.29759.1051.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0702061550010.8424@woody.linux-foundation.org>
	 <1170806622.29759.1063.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0702061615480.8424@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/7/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>
> And yes, then it's almost always correct to "turn things on as needed to
> make everything work out right", while turning things off would be
> actively wrong.

I see a scenario (many others may have got this idea):-

Reading H/W config at the time of doing make (x)config. Idea is to
tell the user.....hey you have SATA disk, so you can't disable this!
(making life easier while compiling the kernel, kinda fast track auto
support)

Can we do this (some how by Kconfig) by reading from the device info
/etc/sysconfig/hwconf or any other way?

If we could do that like above, how to manage dynamic devices - say I
plug in a USB based Printer? Or a simple USB Thumb drive? Giving the
user "Optional Selection" settings from Kconfig? Say, after H/W auto
detection by Kconfig, hand over the user an option - "Buddy, do you
want to add any other device support into this kernel?"

Does this makes sense, Linus?

>
>                 Linus
>

~Akula2
