Return-Path: <linux-kernel-owner+w=401wt.eu-S933901AbXGWB3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933901AbXGWB3z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 21:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760364AbXGWB3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 21:29:46 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:30340 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759916AbXGWB3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 21:29:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=ShTR8iK0mUgvnDMlSYv1z878r1tG32DcRnKUPdNerJQTPAlrZwqffpCvQT7v1PI30OSREATFLk+l+4nn9gKuISxDQSY6K/LqNxaIB2TYW2WKbjsaOVrnna/cFnHE+ZX26aUrZAB7KUV0WegyIp76++8TBihzMpDHf8b/+DAeo3I=
Message-ID: <46A403F9.6020101@googlemail.com>
Date: Mon, 23 Jul 2007 03:27:21 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: Linus 2.6.23-rc1
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <20070723012317.GA17181@linux-sh.org>
In-Reply-To: <20070723012317.GA17181@linux-sh.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt wrote:
> On Sun, Jul 22, 2007 at 02:04:24PM -0700, Linus Torvalds wrote:
>> Lots of architecture updates (for just about all of them - x86[-64], arm, 
>> alpha, mips, ia64, powerpc, s390, sh, sparc, um..), lots of driver updates 
>> (again, all over - usb, net, dvb, ide, sata, scsi, isdn, infiniband, 
>> firewire, i2c, you name it).
>>
> Some of the driver model changes that went in result in a link error:
> 
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `store_uevent':
> : undefined reference to `kobject_actions'
> make: *** [.tmp_vmlinux1] Error 1
> 
> Haven't bisected it yet, but I suppose it's pretty obvious to whoever made the
> changes. ;-)

CONFIG_HOTPLUG=n :)

Try this patch :
http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/driver/kobject-fix-link-error-when-config_hotplug-is-disabled.patch



Regards,

Gabriel
