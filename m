Return-Path: <linux-kernel-owner+w=401wt.eu-S1760310AbYCUWhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760310AbYCUWhj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754844AbYCUWhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:37:31 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:43166 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258AbYCUWha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:37:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mjA7NLOZoIW7oi7Yb7cc+rqSRuxfpEVyH8MOaNJroEVLCxNjUvtZVyBtJjDf008SGnjHpNi2zr5wjDGbm0hIF6YFO5F7HraezDLehldqoo6QXG90SSGdj3XnuPHN7vAKNFVDvh6VXcqeNPiaCJS/sge9eqqof3crnS/yo6ykpOQ=
Message-ID: <86802c440803211537g4921d2d1h95e60eb8692e3fc6@mail.gmail.com>
Date: Fri, 21 Mar 2008 15:37:29 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Glauber Costa" <gcosta@redhat.com>
Subject: Re: [PATCH 58/79] [PATCH] include mach_apic.h in smpboot_64.c and smpboot.c
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu, "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <47E273D0.40402@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12059475744092-git-send-email-gcosta@redhat.com>
	 <12059477273855-git-send-email-gcosta@redhat.com>
	 <1205947732309-git-send-email-gcosta@redhat.com>
	 <12059477371787-git-send-email-gcosta@redhat.com>
	 <12059477421707-git-send-email-gcosta@redhat.com>
	 <12059477472416-git-send-email-gcosta@redhat.com>
	 <12059478321396-git-send-email-gcosta@redhat.com>
	 <12059478362371-git-send-email-gcosta@redhat.com>
	 <86802c440803192356l6ff7e8dg9cfbfd3bc045dcac@mail.gmail.com>
	 <47E273D0.40402@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2008 at 7:25 AM, Glauber Costa <gcosta@redhat.com> wrote:
>
> Yinghai Lu wrote:
>  > On Wed, Mar 19, 2008 at 10:25 AM, Glauber de Oliveira Costa
>  > <gcosta@redhat.com> wrote:
>  >> From: Glauber Costa <gcosta@redhat.com>
>  >>
>  >>  After the inclusion, a lot of files needs fixing for conflicts,
>  >>  some of them in the headers themselves, to accomodate for both
>  >>  i386 and x86_64 versions.
>  >>
>  >>  Signed-off-by: Glauber Costa <gcosta@redhat.com>
>  >>  ---
>  >>   arch/x86/kernel/acpi/boot.c                 |    2 ++
>  >>   arch/x86/kernel/mpparse_64.c                |    2 ++
>  >>   arch/x86/kernel/smpboot.c                   |    2 ++
>  >>   arch/x86/kernel/smpboot_64.c                |    1 +
>  >>   arch/x86/vdso/Makefile                      |    2 +-
>  >>   include/asm-x86/apic.h                      |    1 -
>  >>   include/asm-x86/apicdef.h                   |    6 ------
>  >>   include/asm-x86/mach-default/mach_apic.h    |   11 +++++++++++
>  >>   include/asm-x86/mach-default/mach_apicdef.h |    5 +++++
>  >>   include/asm-x86/smp_64.h                    |    9 +--------
>  >>   10 files changed, 25 insertions(+), 16 deletions(-)
>  >
>  > please don't.
>  >
>  > before this patch
>  > include/asm-x86/mach_apic.h is only for x86_64 only
>  > include/asm-x86/mach-default/mach_apic.h is for i386 only.
>  >
>  > and both have __ASM_MACH_APIC_H defined.
>  >
>  > may need another name?
>  >
>  > YH
>  Another name is possible, but I'd prefer to get rid of the
>  asm-x86/mach_apic.h. The goal here is to have things integrated, so
>  unless really necessary, this is prefered.

anyway, before that I hope you can rename include/asm-x86/mach_apic.h
to include/asm-x86/apic_ext.h

you may move bits from apic_ext.h to mach-default/mach_apic.h later.

YH
