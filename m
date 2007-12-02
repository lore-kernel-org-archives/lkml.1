Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbXLBCZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbXLBCZJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 21:25:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbXLBCY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 21:24:57 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:18080 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbXLBCY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 21:24:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PBKrPDgshnd9EWeeguAiYcdFT5r3+7Yz5uP3uK+yh+FsWjDBjSrty21Nm1soKJjWrv55uJh4/wPNf4YD1fVjJ7WlPbjZNgKPoR6Y7ll+GKLgdKrT9t/8b7uKUAP4PHYeaYVZ7JNmyh5m6axe7DXDGkRtrEdyUEkG4g0uBEL70B8=
Message-ID: <86802c440712011824v4fdac3c4pfaf2f4d5ce93fe18@mail.gmail.com>
Date: Sat, 1 Dec 2007 18:24:55 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] fix x86-32 early fixmap initialization.
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       pageexec@freemail.hu
In-Reply-To: <m163zh5181.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47520F37.20657.4A6846F1@pageexec.freemail.hu>
	 <m163zh5181.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 1, 2007 5:34 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> pageexec@freemail.hu writes:
>
> > hello,
> >
> > i've just noticed that the chunk in i386/kernel/head.S ended up in a
> > weird place, namely, it's not going to be executed as it's just after
> > a 'jmp 3f' and before startup_32_smp, probably not what you intended.
> > on a sidenote, the whole thing can be done in a single insn, like:
> >
> > movl $(swapper_pg_pmd - __PAGE_OFFSET + 0x067), (swapper_pg_dir -
> > __PAGE_OFFSET+ 4092)
> >
> > PS: your email address ebiderman@xmisson.com in the commit seems to
> > be wrong as well.
>
> Yes.  YH refresh one of my old patches and apparently got my email
> address wrong.
>
> Thanks for the reminder I thought we had fixed this problem a while ago.

i sent fix to andrew and andi. but it seems they missed it.

BTW: how about your head32.c patch series.

YH
