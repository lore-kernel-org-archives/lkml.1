Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab0CHVnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 16:43:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755532Ab0CHVnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 16:43:49 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-aio@kvack.org, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: aio: compat_ioctl issue?
References: <4B956E5B.9020302@msgid.tls.msk.ru>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 08 Mar 2010 16:43:42 -0500
In-Reply-To: <4B956E5B.9020302@msgid.tls.msk.ru> (Michael Tokarev's message of
	"Tue, 09 Mar 2010 00:38:35 +0300")
Message-ID: <x497hpm8p69.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev <mjt@tls.msk.ru> writes:

> Hello.
>
> I just come across a situation (next in a long row :)
> when on x86, 32bit userspace does not work with 64bit
> kernel.  This time this is about aio requests.
>
> An application submits some aio job, and it is returned
> immediately (from io_getevents()) with EINVAL error.
> Here's what it does (it's a printf in the application -
> actual arguments as passed to io_submit() and actual
> result received in io_getevents()):
>
> io_submit: lio_opcode=7 reqprio=0 iov=0x9cd7018{0xf5599000,4096}, niov=1, offset=0
> io_getevents: expected 4096 got -22 (EINVAL)
>
> Note that it is not io_submit() which fails (that one
> returns success) but io_getevents(), so it has to be
> down the pipeline somewhere.
>
> Can someone comment this please?  Somehow I was thinking this
> codepath works as - I think anyway - I ran 32bit Oracle database
> with aio support on 64bit kernel, but I may be mistaken.
>
> Kernel is 2.6.33 from kernel.org.

Can you post the program, please?

Thanks,
Jeff
