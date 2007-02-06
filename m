Return-Path: <linux-kernel-owner+w=401wt.eu-S965220AbXBFSNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965220AbXBFSNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 13:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964784AbXBFSNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 13:13:21 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:60551 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965220AbXBFSNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 13:13:20 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Cc: "H. Peter Anvin" <hpa@zytor.com>, vgoyal@in.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: Re : [PATCH] Compressed ia32 ELF file generation for loading by Gujin 1/3
References: <957176.28334.qm@web26903.mail.ukl.yahoo.com>
Date: Tue, 06 Feb 2007 11:12:39 -0700
In-Reply-To: <957176.28334.qm@web26903.mail.ukl.yahoo.com> (Etienne Lorrain's
	message of "Tue, 6 Feb 2007 17:23:55 +0000 (GMT)")
Message-ID: <m1lkjbtaso.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Etienne Lorrain <etienne_lorrain@yahoo.fr> writes:

> H. Peter Anvin wrote:
>> Actually, as far as I can see, he has re-invented having a real-mode 
>> code chunk which then gets run before the protected-mode kernel.  We 
>> already have that!
>
>   I did not claim to have invented anything there, this is just a quite
>  simple C code to execute instead of the current real mode assembly:
>  it is a rewrite with obvious advantages/disadvantages.
>  New features are more that this real-mode function can return an error
>  to the bootloader to tell something to the user, so the user can select
>  another kernel with the right processor, another video mode... with
>  clean error messages - not a crash dump because this assembly
>  instruction is not for that processor.

Having an error handling compatibility that is backwards compatible sounds
interesting.

>   I am still saying that the bootloader knows the root filesystem to
>  be used by the kernel it loads, and that ELF is a clean format to
>  store different sections to be loaded into memory at predefined
>  addresses.

Yes.  Although when you think sections instead of segments I'm a little
worried.

>  Also there isn't any more kernel size limit.

I think as HPA points out we have gotten past that a long time
ago with the bzImage format.

With the right delicacy, and preserving backwards compatibility
with existing bootloaders I think we can achieve things.

The big issue is that sometimes bootloaders are a little bit brittle.

Eric
