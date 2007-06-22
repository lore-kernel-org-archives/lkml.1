Return-Path: <linux-kernel-owner+w=401wt.eu-S1760481AbXFVWzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760481AbXFVWzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 18:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbXFVWzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 18:55:33 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:42937 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797AbXFVWzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 18:55:32 -0400
Date: Fri, 22 Jun 2007 15:57:08 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH] x86-64: disable the GART before allocate aperture
In-reply-to: <20070622235456.08999aa7@the-village.bc.nu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Muli Ben-Yehuda <muli@il.ibm.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai.Lu@Sun.COM
Message-id: <467C53C4.4060004@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <200706221219.16243.yinghai.lu@sun.com>
 <20070622193124.GG5051@rhun.smartcity.com>
 <20070622213327.69663288@the-village.bc.nu>
 <m18xabbrp6.fsf@ebiederm.dsl.xmission.com>
 <20070622231951.4d516215@the-village.bc.nu>
 <m1tzszaadm.fsf@ebiederm.dsl.xmission.com> <467C5074.6050103@sun.com>
 <20070622235456.08999aa7@the-village.bc.nu>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:

> Don't disable it, just don't touch it or any of its mappings. Leave it
> *alone*, and use swiotlb. That'll maximise the ability to recover stuff
> from the kexec kernel (since for one you may want to dump the gart when a
> 3d app goes kerblam)

How about LinuxBIOS + Kernel ===> Final kernel path?
someday EFI(PEI) + Kernel ===> Final kernel path need that too.

or the normal kexec path still could have clean shutdown.

YH
