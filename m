Return-Path: <linux-kernel-owner+w=401wt.eu-S1751722AbXD1UTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbXD1UTb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 16:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbXD1UTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 16:19:31 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:33360 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbXD1UTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 16:19:30 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeff Garzik <jeff@garzik.org>
Cc: Andi Kleen <ak@suse.de>, patches@x86-64.org,
       Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for relocatable bzImage
References: <20070428758.455116000@suse.de>
	<20070428175909.1D09D151CA@wotan.suse.de> <46338D72.70402@garzik.org>
Date: Sat, 28 Apr 2007 14:18:14 -0600
In-Reply-To: <46338D72.70402@garzik.org> (Jeff Garzik's message of "Sat, 28
	Apr 2007 14:07:46 -0400")
Message-ID: <m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:

> Andi Kleen wrote:
>> From: Vivek Goyal <vgoyal@in.ibm.com>
>> 
>> 
>> o Extend the bzImage protocol (same as i386) to allow bzImage loaders to
>>   load the protected mode kernel at non-1MB address. Now protected mode
>>   component is relocatable and can be loaded at non-1MB addresses.
>> 
>> o As of today kdump uses it to run a second kernel from a reserved memory
>>   area.
>> 
>> Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
>> Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
>> Signed-off-by: Andi Kleen <ak@suse.de>
>
> Can you point to / link to threads where the bootloader folks looked 
> over the reloc changes from their side, and commented?

Jeff what is your concern.

The boot protocol change is in 2.6.21 for arch/i386.

HPA looked at it a while ago.

All it does is set a flag that tells a bootloader.
"Hey. I can run when loaded a non-default address, and this is what
 you have to align me to."

All relocation processing happens in the kernel itself.

So it is all pretty trivial.

Eric
