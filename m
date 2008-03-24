Return-Path: <linux-kernel-owner+w=401wt.eu-S1755018AbYCXWoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbYCXWoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 18:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753785AbYCXWoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 18:44:16 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:60822 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbYCXWoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 18:44:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tbgI1P1uxXkONjmr+ogn2plMCY5mhIgphdCSAmrD5vBXn3x3/H5XWDBmibmxJ3fDW2EeRQ2B4uvRE34E0a2iCGSX6ZA0cFGH/tCFBWBrJzS+o7p6l01ymPQ0n0OtCq5t9INlsJ/DCZ+X86hXP6uS+85QDxY/nX2QV/ihy8aE51o=
Message-ID: <86802c440803241544w2a250e05wd35e48356628dbbe@mail.gmail.com>
Date: Mon, 24 Mar 2008 15:44:13 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Glauber Costa" <gcosta@redhat.com>
Subject: Re: [PATCH 2/2] move apic declarations to mach_apic.h
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       mingo@elte.hu, tglx@linutronix.de
In-Reply-To: <1206388361-17265-2-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1206388361-17265-1-git-send-email-gcosta@redhat.com>
	 <1206388361-17265-2-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2008 at 12:52 PM, Glauber Costa <gcosta@redhat.com> wrote:
> take them out of the x86_64-specific asm/mach_apic.h
>
>  Signed-off-by: Glauber Costa <gcosta@redhat.com>
>  ---
>   arch/x86/kernel/apic_64.c                |    2 -
>   arch/x86/kernel/io_apic_64.c             |    2 -
>   arch/x86/kernel/setup_64.c               |    2 -
>   include/asm-x86/mach-default/mach_apic.h |   80 ++++++++++++++++--------------
>   include/asm-x86/mach_apic.h              |   26 ----------
>   5 files changed, 46 insertions(+), 66 deletions(-)
>
>  diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
>  index 206278f..7dd6250 100644
>  --- a/arch/x86/kernel/apic_64.c
>  +++ b/arch/x86/kernel/apic_64.c
>  @@ -34,7 +34,6 @@ #include <asm/mtrr.h>
>   #include <asm/mpspec.h>
>   #include <asm/hpet.h>
>   #include <asm/pgalloc.h>
>  -#include <asm/mach_apic.h>
>   #include <asm/nmi.h>
>   #include <asm/idle.h>
>   #include <asm/proto.h>
>  @@ -42,6 +41,7 @@ #include <asm/timex.h>
>   #include <asm/apic.h>
>
>   #include <mach_ipi.h>
>  +#include <mach_apic.h>

good. include/asm-x86/mach_apic.h is gone.

YH
