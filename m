Return-Path: <linux-kernel-owner+w=401wt.eu-S1752894AbZLYE4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbZLYE4i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 23:56:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbZLYE4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 23:56:38 -0500
Received: from mail-qy0-f194.google.com ([209.85.221.194]:58421 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbZLYE4h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 23:56:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Y3DfWpmTMGShakE42xOaNAvK1KWUXvackIaVnczL1Rh/C5NJ/WC3zhlNwUWTToA5vq
         KSzQjoacEYMMS3eeOP4ufJuT+dvwcXGx0O3wjuGZuhOiJHH3vzMYyPo7nQ1mUHoW4w1R
         st/yAJodUsYyPzpklw4i3xlBtrZcfwirz46rg=
MIME-Version: 1.0
In-Reply-To: <f19d625d0912240309g5c066de7pc4dc9d95c084d4df@mail.gmail.com>
References: <f19d625d0912240309g5c066de7pc4dc9d95c084d4df@mail.gmail.com>
Date: Fri, 25 Dec 2009 12:56:36 +0800
Message-ID: <2375c9f90912242056h29f20dc5rb3f891c732e0d362@mail.gmail.com>
Subject: Re: 2.6.28.10 - kernel BUG at mm/rmap.c:725
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: CoolCold <coolthecold@gmail.com>
Cc: Linux kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       hugh.dickins@tiscali.co.uk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 24, 2009 at 7:09 PM, CoolCold <coolthecold@gmail.com> wrote:
> 3 days ago LA on server become very high and it was working very
> strange, so was rebooted. There are such entryies in log about kernel
> bug - kernel BUG at mm/rmap.c:725! . Googling didn't provide me with
> exact answer is it bug or hardware problems, something similar was
> here https://bugs.launchpad.net/ubuntu/+source/linux/+bug/252977/comments/56
> In general this server had number of unexpected stalls during several
> months, but there is no ipkvm, so i can't say where something on
> console or not. Hope you will help.
>
> Kernel version is 2.6.28.10 , self-builded. System - Debian stable/testing.
>
> Please reply to me directly, cuz i'm not subsribed to list.
>
> Dec 21 22:05:01 gamma kernel: Eeek! page_mapcount(page) went negative! (-1)
> Dec 21 22:05:01 gamma kernel:   page pfn = 1f2c81
> Dec 21 22:05:01 gamma kernel:   page->flags = 20000000008007c
> Dec 21 22:05:01 gamma kernel:   page->count = 2
> Dec 21 22:05:01 gamma kernel:   page->mapping = ffff8801fd870b58
> Dec 21 22:05:01 gamma kernel:   vma->vm_ops = 0xffffffff80535020
> Dec 21 22:05:01 gamma kernel:   vma->vm_ops->fault = shmem_fault+0x0/0x69
> Dec 21 22:05:01 gamma kernel:   vma->vm_file->f_op->mmap = shmem_mmap+0x0/0x2e
> Dec 21 22:05:01 gamma kernel: ------------[ cut here ]------------
> Dec 21 22:05:01 gamma kernel: kernel BUG at mm/rmap.c:725!

Hey,

commit 3dc147414cc already removed this BUG(), not sure
how serious this is...

Adding mm people into Cc.

Thanks.
