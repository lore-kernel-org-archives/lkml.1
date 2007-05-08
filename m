Return-Path: <linux-kernel-owner+w=401wt.eu-S966751AbXEHRXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966751AbXEHRXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 13:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966597AbXEHRXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 13:23:14 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:58709 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966340AbXEHRXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 13:23:13 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: yhlu <yhlu.kernel@gmail.com>
Cc: vgoyal@in.ibm.com, "H. Peter Anvin" <hpa@zytor.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Gerd Hoffmann" <kraxel@redhat.com>, "Jeff Garzik" <jeff@garzik.org>,
       patches@x86-64.org, linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for relocatable bzImage
References: <4634483E.9030307@goop.org> <46385A8A.6070405@redhat.com>
	<4638AB55.20408@goop.org> <4638F9BE.8090508@zytor.com>
	<4638FC39.4010101@goop.org> <4638FE1B.9050901@zytor.com>
	<46390523.5010809@goop.org> <463909AF.9040205@zytor.com>
	<20070503045031.GA5794@in.ibm.com>
	<m1tzuuv24z.fsf@ebiederm.dsl.xmission.com>
	<86802c440705080941y69ddd5d6lab170c5f3967f148@mail.gmail.com>
Date: Tue, 08 May 2007 11:18:27 -0600
In-Reply-To: <86802c440705080941y69ddd5d6lab170c5f3967f148@mail.gmail.com>
	(yhlu.kernel@gmail.com's message of "Tue, 8 May 2007 09:41:09 -0700")
Message-ID: <m1sla7i68s.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

yhlu <yhlu.kernel@gmail.com> writes:

> Eric,
>
> With the latest change that make vmlinux to be elf64 and make bzImage
> do switch to 64bit long mode, the kernel started via kexec can not get
> VGA console. but the serial console works well. I wonder if the
> setup.S is skipped in bzImage via kexec path.

Yes.  setup.S has always been skipped by bzImage via the kexec path
unless you explicitly tell /sbin/kexec to use the 16bit entry point.

Is not having a VGA console a new thing, or it something you just noticed?

Eric
