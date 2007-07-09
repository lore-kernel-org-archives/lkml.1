Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbXGILG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbXGILG0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 07:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbXGILGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 07:06:19 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:20314 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbXGILGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 07:06:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZdZOiwjb8vgDCTsQEVg8IBND8L05sjXcobJtL88m49c4/ejWyVr0PuPtYDt/oeTXBlc7DxLromC9fALQk+UX7nyEk7bUjNM7i6iOfrEa6m+mI0UfqD9dSm2YM3CeFNFm2U+ZSJlSRPUiEU0iTea4Vod5JL+W/35sdtqhM61UaWU=
Message-ID: <ca35ce500707090406n7b25f0bfp987a56ca79e24462@mail.gmail.com>
Date: Mon, 9 Jul 2007 13:06:18 +0200
From: mikie <mikie.pl@gmail.com>
To: "Duncan Sands" <duncan.sands@math.u-psud.fr>
Subject: Re: understanding firmware loader for speedtouch (kernel 2.6.21.5)
Cc: "Indan Zupancic" <indan@nul.nu>, linux-kernel@vger.kernel.org
In-Reply-To: <200707091250.37670.duncan.sands@math.u-psud.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ca35ce500707060554v71ebdca3k8ef18e4c0a44c9cb@mail.gmail.com>
	 <58019.81.207.0.53.1183749400.squirrel@secure.samage.net>
	 <ca35ce500707090149x78a424f6t9d687893c0d657f6@mail.gmail.com>
	 <200707091250.37670.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/7/9, Duncan Sands <duncan.sands@math.u-psud.fr>:
> Hi,
>
> > On my system the /proc/sys/kernel/hotplug points to /sbin/hotplug.
> > I copied your script to /sbin/hotplug and also added simple logging,
> > so I can see whenever the script is being started. It turns out that
> > the script is not started at all by the kernel...
>
> did you turn hotplug on in your kernel's .config?

Yes:
cat /usr/src/linux/.config |grep HOTPLUG
CONFIG_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
# CONFIG_HOTPLUG_PCI is not set

Regards,
MK
