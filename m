Return-Path: <linux-kernel-owner+w=401wt.eu-S1031012AbXD2SKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031012AbXD2SKq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 14:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031047AbXD2SKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 14:10:46 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:48980 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031012AbXD2SKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 14:10:44 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Jeff Garzik <jeff@garzik.org>,
       Andi Kleen <ak@suse.de>, patches@x86-64.org,
       Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for relocatable bzImage
References: <20070428758.455116000@suse.de>
	<20070428175909.1D09D151CA@wotan.suse.de> <46338D72.70402@garzik.org>
	<m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com> <4634483E.9030307@goop.org>
	<4634DB24.7020408@zytor.com>
Date: Sun, 29 Apr 2007 12:10:13 -0600
In-Reply-To: <4634DB24.7020408@zytor.com> (H. Peter Anvin's message of "Sun,
	29 Apr 2007 10:51:32 -0700")
Message-ID: <m1mz0r6ohm.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Jeremy Fitzhardinge wrote:
>> Eric W. Biederman wrote:
>>> All it does is set a flag that tells a bootloader.
>>> "Hey. I can run when loaded a non-default address, and this is what
>>>  you have to align me to."
>>>
>>> All relocation processing happens in the kernel itself.
>>>   
>> 
>> Is it possible to decompress and extract the kernel image from the
>> bzImage without executing it?  Ie, is there enough information to find
>> the compressed data part of the bzImage by inspection?
>> 
>> At some point we'll need to change the Xen domain builder to handle
>> bzImage files, and it would be best if we didn't need to run them.
>> 
>
> Probabilistically, you might be able to (search for a gzip header), but
> it is *definitely* not guaranteed by protocol.

I suspect the issue isn't so much skipping the decompression
but either getting at the Xen ELF notes or bypassing privileged instructions.


Eric
