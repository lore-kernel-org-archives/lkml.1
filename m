Return-Path: <linux-kernel-owner+w=401wt.eu-S1755049AbYCTG46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbYCTG46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 02:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbYCTG4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 02:56:49 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:5651 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbYCTG4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 02:56:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kJ7T+jhftJ8FnM+wOQKi/klLPACfZEwHwUH65CRpaKKG+FjBo9e6XRWg6WJl0IsOK8E83fwJC461hCt31XlxlbXov3d1iLfyzKNimOKl7ZmOSODveiC6YTEQbJfrHHw/o6UDpGvUan50ej3kFnoa0Zs1v/b0ltDpqT5Bgr05vaQ=
Message-ID: <86802c440803192356l6ff7e8dg9cfbfd3bc045dcac@mail.gmail.com>
Date: Wed, 19 Mar 2008 23:56:47 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Glauber de Oliveira Costa" <gcosta@redhat.com>
Subject: Re: [PATCH 58/79] [PATCH] include mach_apic.h in smpboot_64.c and smpboot.c
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu, ak@suse.de
In-Reply-To: <12059478362371-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12059475744092-git-send-email-gcosta@redhat.com>
	 <1205947719906-git-send-email-gcosta@redhat.com>
	 <12059477234148-git-send-email-gcosta@redhat.com>
	 <12059477273855-git-send-email-gcosta@redhat.com>
	 <1205947732309-git-send-email-gcosta@redhat.com>
	 <12059477371787-git-send-email-gcosta@redhat.com>
	 <12059477421707-git-send-email-gcosta@redhat.com>
	 <12059477472416-git-send-email-gcosta@redhat.com>
	 <12059478321396-git-send-email-gcosta@redhat.com>
	 <12059478362371-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2008 at 10:25 AM, Glauber de Oliveira Costa
<gcosta@redhat.com> wrote:
> From: Glauber Costa <gcosta@redhat.com>
>
>  After the inclusion, a lot of files needs fixing for conflicts,
>  some of them in the headers themselves, to accomodate for both
>  i386 and x86_64 versions.
>
>  Signed-off-by: Glauber Costa <gcosta@redhat.com>
>  ---
>   arch/x86/kernel/acpi/boot.c                 |    2 ++
>   arch/x86/kernel/mpparse_64.c                |    2 ++
>   arch/x86/kernel/smpboot.c                   |    2 ++
>   arch/x86/kernel/smpboot_64.c                |    1 +
>   arch/x86/vdso/Makefile                      |    2 +-
>   include/asm-x86/apic.h                      |    1 -
>   include/asm-x86/apicdef.h                   |    6 ------
>   include/asm-x86/mach-default/mach_apic.h    |   11 +++++++++++
>   include/asm-x86/mach-default/mach_apicdef.h |    5 +++++
>   include/asm-x86/smp_64.h                    |    9 +--------
>   10 files changed, 25 insertions(+), 16 deletions(-)

please don't.

before this patch
include/asm-x86/mach_apic.h is only for x86_64 only
include/asm-x86/mach-default/mach_apic.h is for i386 only.

and both have __ASM_MACH_APIC_H defined.

may need another name?

YH
