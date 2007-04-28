Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbXD1UsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbXD1UsP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 16:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754775AbXD1UsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 16:48:15 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:45308 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723AbXD1UsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 16:48:13 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeff Garzik <jeff@garzik.org>, Andi Kleen <ak@suse.de>, patches@x86-64.org,
       Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for relocatable bzImage
References: <20070428758.455116000@suse.de>
	<20070428175909.1D09D151CA@wotan.suse.de> <46338D72.70402@garzik.org>
	<m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com>
	<4633B0BB.6080600@zytor.com>
Date: Sat, 28 Apr 2007 14:46:18 -0600
In-Reply-To: <4633B0BB.6080600@zytor.com> (H. Peter Anvin's message of "Sat,
	28 Apr 2007 13:38:19 -0700")
Message-ID: <m1bqh8dy79.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Eric W. Biederman wrote:
>> 
>> The boot protocol change is in 2.6.21 for arch/i386.
>> 
>> HPA looked at it a while ago.
>> 
>> All it does is set a flag that tells a bootloader.
>> "Hey. I can run when loaded a non-default address, and this is what
>>  you have to align me to."
>> 
>> All relocation processing happens in the kernel itself.
>> 
>> So it is all pretty trivial.
>> 
>
> Indeed.  We *did* find some problems with Grub with the early versions,
> those were addressed.

We found some failures that weren't root caused so we went to this
more conservative version.

RHEL5 is actually shipping the original version of these patches if I
recall correctly.

Eric
