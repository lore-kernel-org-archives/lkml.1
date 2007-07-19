Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbXGSUAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbXGSUAo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 16:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754336AbXGSUAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 16:00:18 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:51327 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbXGSUAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 16:00:16 -0400
Date: Thu, 19 Jul 2007 22:00:15 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Greg KH <gregkh@suse.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kay.sievers@vrfy.org
Subject: Re: kobject link failure
In-Reply-To: <20070719191846.GA18871@suse.de>
Message-ID: <Pine.LNX.4.64.0707192159510.31013@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0707191956510.31013@fbirervta.pbzchgretzou.qr>
 <20070719191846.GA18871@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 19 2007 12:18, Greg KH wrote:
>On Thu, Jul 19, 2007 at 08:03:06PM +0200, Jan Engelhardt wrote:
>> 
>> top is 275afcac9953ece0828972edeab9684cfe1a5ef3, error is:
>>   LD      .tmp_vmlinux1
>> drivers/built-in.o: In function `store_uevent':
>> core.c:(.text+0x20ebb): undefined reference to `kobject_actions'
>> core.c:(.text+0x20edd): undefined reference to `kobject_actions'
>> make[1]: *** [.tmp_vmlinux1] Error 1
>> make: *** [_all] Error 2
>> 
>> .config attached. Is it because of CONFIG_HOTPLUG=n?
>
>Yes it is, are you really sure you want that?  :)

I doubt I ever have something to hotplug on ye olde ancient i386.



	Jan
-- 
