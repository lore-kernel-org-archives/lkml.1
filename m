Return-Path: <linux-kernel-owner+w=401wt.eu-S1031356AbXEHTMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031356AbXEHTMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 15:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031372AbXEHTMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 15:12:37 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38853 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031349AbXEHTMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 15:12:35 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: yhlu <yhlu.kernel@gmail.com>
Cc: vgoyal@in.ibm.com, "H. Peter Anvin" <hpa@zytor.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Gerd Hoffmann" <kraxel@redhat.com>, "Jeff Garzik" <jeff@garzik.org>,
       patches@x86-64.org, linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for relocatable bzImage
References: <4634483E.9030307@goop.org> <4638FC39.4010101@goop.org>
	<4638FE1B.9050901@zytor.com> <46390523.5010809@goop.org>
	<463909AF.9040205@zytor.com> <20070503045031.GA5794@in.ibm.com>
	<m1tzuuv24z.fsf@ebiederm.dsl.xmission.com>
	<86802c440705080941y69ddd5d6lab170c5f3967f148@mail.gmail.com>
	<m1sla7i68s.fsf@ebiederm.dsl.xmission.com>
	<86802c440705081033s19365843i5b955ae175de73eb@mail.gmail.com>
	<86802c440705081151r6bfd82e4o50c6a34b2b2a833f@mail.gmail.com>
Date: Tue, 08 May 2007 13:11:36 -0600
In-Reply-To: <86802c440705081151r6bfd82e4o50c6a34b2b2a833f@mail.gmail.com>
	(yhlu.kernel@gmail.com's message of "Tue, 8 May 2007 11:51:35 -0700")
Message-ID: <m1k5vji107.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

yhlu <yhlu.kernel@gmail.com> writes:

> Eric,
>
> i tried to load vmlinux with kexec and got
> Ramdisks not supported with generic elf arguments
>
> So i use mkelfImage with my patch ( convert elf64 to elf32) to make
> another elf32. and loaded with kexec and can not get vga console too.
> ---serial console works well.
>
> the mkelfImage 2.7 patch is at
> http://72.14.253.104/search?q=cache:fuxOvFw3ZIIJ:lists.osdl.org/pipermail/fastboot/attachments/20061108/009064a6/attachment.obj+mkelfImage+2.7+patch&hl=en&ct=clnk&cd=4&gl=us
>
> So the problem is not bzImage related, but in somewhere in vmlinux.

Odd.   Is it specifically these patches?
Or is it just the recent kernel from Linus?

You might try a git-bisect, or if it is just these patches
walking through them one-by-one.

Eric
