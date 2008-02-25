Return-Path: <linux-kernel-owner+w=401wt.eu-S1760971AbYBYWdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760971AbYBYWdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:33:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757481AbYBYWcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:32:48 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:47526 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757128AbYBYWcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:32:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gVs3L4Wq8HcACvCtsY0h5S65qkF2e4r3Zk5x++5u4QP/unvHlJqLx4D8I0ut5pQ35Mhcz1+YQVsYNmnmP4T41IC1o5P7IYXoEGYPQ9662cSvpsrOa7c5ENpmLGECQCzs9XluT00WxAv+XHW0vJKHeRkSDHqMXL/MvwTkT0loUDc=
Message-ID: <8499950a0802251432q1e59e542nfa06f66becef63aa@mail.gmail.com>
Date: Mon, 25 Feb 2008 23:32:44 +0100
From: "Oleg Verych" <olecom@gmail.com>
To: "Willy Tarreau" <w@1wt.eu>
Subject: Re: [PATCH] Compress kernel modules on installation.
Cc: "Steve Brokenshire" <sbrokenshire@xestia.co.uk>,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
In-Reply-To: <20080225221953.GX8953@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080225214209.a3f79327.sbrokenshire@xestia.co.uk>
	 <8499950a0802251417l7a2fff25q7fa57fce57369b1b@mail.gmail.com>
	 <20080225221953.GX8953@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 11:19 PM, Willy Tarreau:
>
> On Mon, Feb 25, 2008 at 11:17:23PM +0100, Oleg Verych wrote:
>  > On Mon, Feb 25, 2008 at 10:42 PM, Steve Brokenshire:
>  > > Hi,
>  > >
>  > >  (I've sent this to the linux-kbuild and linux-kernel lists as this
>  > >  patch modifies the Makefile.modinst file. I also don't subscribe to the
>  > >  linux-kbuild and linux-kernel mailing lists so can I have any replies
>  > >  CC'ed to me please)
>  >
>  > And what if i like bzip2 (yea sometimes better) or 7zip (better if !EMBEDDED)
>  > or whatever?
>  >
>  > It's pure user/distro question.
>
>  not exactly, as only gzip is supported by module-init-tools. However,
>  if you come up with a patch to implement lzma or equivalent for
>  module-init-tools, it may be useful.

Oh, come on! It's userspace, i have scripts managing existence/compression
on per-file basis on my comp. If most distros just drop thousands of useless
(sometimes compressed) stuff to your harddisk, it's not kernel's or
modules-init-tools'
problem.

Also having compressed over compressed stuff, like on initramfs booting image
with such modules (if by defaults) may cause bigger file, more CPU overhead.

It is userspace and all that policy stuff, etc., etc.

Want to make a minidistro on lkml? Well, i see klibc working fine already.
_______
