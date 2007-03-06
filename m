Return-Path: <linux-kernel-owner+w=401wt.eu-S932418AbXCFMQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418AbXCFMQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 07:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932442AbXCFMQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 07:16:58 -0500
Received: from village.ehouse.ru ([193.111.92.18]:3726 "EHLO mail.ehouse.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932418AbXCFMQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 07:16:57 -0500
From: "Alexander Y. Fomichev" <gluk@php4.ru>
Reply-To: "Alexander Y. Fomichev" <gluk@php4.ru>
To: "Nish Aravamudan" <nish.aravamudan@gmail.com>
Subject: Re: kernel BUG at arch/x86_64/mm/../../i386/mm/hugetlbpage.c:140!
Date: Tue, 6 Mar 2007 15:16:53 +0300
User-Agent: KMail/1.9.6
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       admin@list.net.ru
References: <200703021651.16050.gluk@php4.ru> <29495f1d0703021338k41bad9d3teaf93c8abcbfc152@mail.gmail.com>
In-Reply-To: <29495f1d0703021338k41bad9d3teaf93c8abcbfc152@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703061516.53928.gluk@php4.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 March 2007, Nish Aravamudan wrote:
> On 3/2/07, Alexander Y. Fomichev <gluk@php4.ru> wrote:
> > G'day
> >
> > I'm hit a bug on 2.6.21-rc1 at startup of mysql with 'large-pages' flag
> > set. (at this point mysql trying to allocate pages from hugetlb pool by
> > sysv shm syscalls). Seems like it could be triggered by previous badness
> > and probably hugetlb itself is not related. Anyway i couldn't reproduce
> > it by now with 2.6.21-rc2 git commit
> > 562aa1d4c6a874373f9a48ac184f662fbbb06a04. Very likely it has been fixed
> > somwhere between 2.6.21-rc1 and -rc2, but i couldn't find something
> > related by git log so any comments are welcome.
>
> Adam Litke posted a bug fix for hugetlb shm:
> http://lkml.org/lkml/2007/3/1/381.
>
> Does that help fix your problem too?
>
> Thanks,
> Nish

Yep, it is, though Adam address this patch powerpc and ia64 issue but
x86_64 (and probably i386) affected too.

-- 
Best regards.
        Alexander Y. Fomichev <gluk@php4.ru>
        Public PGP key: http://sysadminday.org.ru/gluk.asc
