Return-Path: <linux-kernel-owner+w=401wt.eu-S1756569AbXFLPRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbXFLPRV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 11:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbXFLPRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 11:17:12 -0400
Received: from ik-out-1112.google.com ([66.249.90.178]:4188 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681AbXFLPRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 11:17:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gwhzirpd0GjdQg1I4GFh1O4rJQY3KTl3JhsciQXvL+N8atwk5jZaS/Y9lTRGdswZiLqDVi21HKaWEbhuKmSN+X9Vwhm0vaCW0troNkg9d7k87MUk2QLc9cZa7pyIs8bNsjL63tz5iF445PlDQ9HQoR0/l5uG/o5SWhyc7oseGxQ=
Message-ID: <f24d23310706120817m741b1cb4g9ac6f5469274f307@mail.gmail.com>
Date: Tue, 12 Jun 2007 20:47:09 +0530
From: "debian developer" <debiandev@gmail.com>
To: "Federico Paparoni" <federico.paparoni@gmail.com>
Subject: Re: Linux kernel 2.4 programming problem
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <7f7732360706120654i34f34da8q6428e41bc5a76728@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7f7732360706120654i34f34da8q6428e41bc5a76728@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please look into http://kernelnewbies.org

On 6/12/07, Federico Paparoni <federico.paparoni@gmail.com> wrote:
> Hi all,
> i'm trying to create a simple system call in a kernel 2.4 distribution.
> I read guide/articles like this
>
> http://irfanhabib.wordpress.com/2006/10/01/adding-a-system-call-linux-24x/
>
> All the articles say the same things, but the implementation of my new
> system call doesn't work.
> I create a new entry in arch/i386/kernel/entry.S
> I create a new entry in include/asm/unistd.h
> I create a new function with the asmlinkage prefix in a source file
> already defined (in ipc/sem.c for example)
>
> When i create my user program, it doesn't work. Firstly when i try to
> compile i receive a problem like this
>
> : undefined reference to 'errno'
>
> Then I include errno.h (also if i don't understand this step) and the
> compilation works, but the syscall neverworks, because the call always
> return -1.
>
> Any help?
> Any tutorial FOR DUMMY MAN that someone already used?
>
> Cheers
>
> Federico
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
