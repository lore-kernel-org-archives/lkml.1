Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbXEHSvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbXEHSvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 14:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbXEHSvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 14:51:38 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:1149 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336AbXEHSvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 14:51:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VCWWELauDFIX+qi97w6HjpxWHl0OSYCNmeIoerJIyrkGZZeubZygjRx5ifgYC1ZI5ysf0RuLsUguNEL78c1U6OQgyRIOzGlz8isKNKvAGP0dqKFyflm+N0LOSQjA1SAIZG1yxEgyWhYCf+d20ihQGyY5ChOgOF6sjp4uKuTB2vQ=
Message-ID: <86802c440705081151r6bfd82e4o50c6a34b2b2a833f@mail.gmail.com>
Date: Tue, 8 May 2007 11:51:35 -0700
From: yhlu <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for relocatable bzImage
Cc: vgoyal@in.ibm.com, "H. Peter Anvin" <hpa@zytor.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Gerd Hoffmann" <kraxel@redhat.com>, "Jeff Garzik" <jeff@garzik.org>,
       patches@x86-64.org, linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <86802c440705081033s19365843i5b955ae175de73eb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4634483E.9030307@goop.org> <4638FC39.4010101@goop.org>
	 <4638FE1B.9050901@zytor.com> <46390523.5010809@goop.org>
	 <463909AF.9040205@zytor.com> <20070503045031.GA5794@in.ibm.com>
	 <m1tzuuv24z.fsf@ebiederm.dsl.xmission.com>
	 <86802c440705080941y69ddd5d6lab170c5f3967f148@mail.gmail.com>
	 <m1sla7i68s.fsf@ebiederm.dsl.xmission.com>
	 <86802c440705081033s19365843i5b955ae175de73eb@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric,

i tried to load vmlinux with kexec and got
Ramdisks not supported with generic elf arguments

So i use mkelfImage with my patch ( convert elf64 to elf32) to make
another elf32. and loaded with kexec and can not get vga console too.
---serial console works well.

the mkelfImage 2.7 patch is at
http://72.14.253.104/search?q=cache:fuxOvFw3ZIIJ:lists.osdl.org/pipermail/fastboot/attachments/20061108/009064a6/attachment.obj+mkelfImage+2.7+patch&hl=en&ct=clnk&cd=4&gl=us

So the problem is not bzImage related, but in somewhere in vmlinux.

YH
