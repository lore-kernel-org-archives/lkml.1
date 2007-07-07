Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbXGGR7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbXGGR7B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 13:59:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbXGGR6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 13:58:53 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:2685 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbXGGR6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 13:58:52 -0400
Date: Sat, 7 Jul 2007 19:58:51 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Ingo Freund <linux-kernel-news@e-dict.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: [seems to be SOLVED] Re: md device files missing at boot time
In-Reply-To: <468CEED7.3020109@e-dict.net>
Message-ID: <Pine.LNX.4.64.0707071957550.1536@fbirervta.pbzchgretzou.qr>
References: <468CB6DC.5020102@e-dict.net> <468CEED7.3020109@e-dict.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 5 2007 15:15, Ingo Freund wrote:
>On 05.07.2007 11:16, Ingo Freund wrote (please find the answer below the original text):
>> Hi folks,
>> 
>> I could temporarily only read your answers in archives.
>> Thank you for your reaction.
>> Hopefully this answer doesn't break the thread.
>> If it does:
>> sorry for it, there were some mail mail problems
>> which stopped our server receiving mails from this list
>> and the list auto-unsubscribed me and stopped sending mails :-(
>> But it is all fixed now.
>> 
>> @Kay
>> How did you build the initramfs image? /sbin/mkinitrd?
>> 
>> Did you add md support to the image?
>> 
>> Both "Yes".
>> included modules are (in opensuses /etc/sysconfig/kernel:
>> INITRD_MODULES="raid1 md reiserfs sym53c8xx pata_serverworks edd"
>> 
>> 
>
>@Kay
>there was a hidden hint in your text.
>"mkinitrd -f md"  made it at least for boot with initramfs

That's rather a hack.

I suppose your problem is that mdadm is not inside the initrd.
(gzip -cd /boot/initrd | cpio -t)
Make sure /etc/fstab lists an md device, then mdadm should be added
automatically.


	Jan
-- 
