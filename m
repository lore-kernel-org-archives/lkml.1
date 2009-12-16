Return-Path: <linux-kernel-owner+w=401wt.eu-S964946AbZLPTgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964946AbZLPTgy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 14:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964929AbZLPTgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 14:36:54 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:44140 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964900AbZLPTgx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 14:36:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=okmijgVUkpjjydxokjoHulFkjDyiQTZswCEVyvQPI693dh+4n7jhD5P7HZwexvk1rx
         BVF7I7mQrz81L+/Kp9foYZokK3M2DQsXOOH8iiE1aPa0Os/4Xn6GGMT8qp/o4Zxz4CzO
         0afqyp+OaZ77OhQ1q4Iig/NfN2dkEFF+JIWNE=
MIME-Version: 1.0
In-Reply-To: <20419.1260982769@redhat.com>
References: <1260921350-6539-1-git-send-email-vapier@gentoo.org> 
	<20419.1260982769@redhat.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 16 Dec 2009 14:36:32 -0500
Message-ID: <8bd0f97a0912161136g19fdc4eeif977b56c98464f8b@mail.gmail.com>
Subject: Re: [uClinux-dev] Re: [PATCH] NOMMU: add [stack] label to per-process 
	maps output
To: uClinux development list <uclinux-dev@uclinux.org>
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       David McCullough <davidm@snapgear.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 11:59, David Howells wrote:
> Mike Frysinger wrote:
>
>> +             if (vma->vm_start <= mm->start_brk &&
>> +                             vma->vm_end >= mm->brk) {
>
> Hmmm...  That ought to involve mm->start_stack somewhere...  (Or, more
> probably, task->stack_start:-/)

in practice, it's probably always the same result, but you're right of
course.  when i looked through the elf_fdpic code, i looked at the
start_brk mmap() and missed the later start_stack assignment later on.
-mike
