Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab0CHWZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 17:25:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755732Ab0CHWZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 17:25:30 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-aio@kvack.org, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: aio: compat_ioctl issue?
References: <4B956E5B.9020302@msgid.tls.msk.ru>
	<x497hpm8p69.fsf@segfault.boston.devel.redhat.com>
	<4B957122.4060007@msgid.tls.msk.ru>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 08 Mar 2010 17:25:24 -0500
In-Reply-To: <4B957122.4060007@msgid.tls.msk.ru> (Michael Tokarev's message of
	"Tue, 09 Mar 2010 00:50:26 +0300")
Message-ID: <x49mxyi78ob.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev <mjt@tls.msk.ru> writes:

> Jeff Moyer wrote:
>> Michael Tokarev <mjt@tls.msk.ru> writes:
>> 
>>> Hello.
>>>
>>> I just come across a situation (next in a long row :)
>>> when on x86, 32bit userspace does not work with 64bit
>>> kernel.  This time this is about aio requests.
>>>
>>> An application submits some aio job, and it is returned
>>> immediately (from io_getevents()) with EINVAL error.
> []
>> Can you post the program, please?
>
> The program which I'm trying is quite big - it's qemu-kvm
> v. 0.12.3 compiled with --enable-linux-aio.  I bugged
> kvm folks about non-working aio support but immediately
> realized it's 32/64bit issue in the kernel, since 64bit
> kvm works just fine on the same kernel (which is 64bits).
> So I added 2 printfs into its linux-aio.c and re-run it.

[snip]

Well, I'm not experiencing such problems.  I can run a 32bit aio
application on a 64bit kernel just fine with 2.6.31, 2.6.32 and
2.6.34-rc1.

Could you maybe print out the values that are passed to io_getevents?

Thanks,
Jeff
