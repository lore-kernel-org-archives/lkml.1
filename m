Return-Path: <linux-kernel-owner+w=401wt.eu-S1758518AbYCTSA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518AbYCTSA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 14:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755943AbYCTSAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 14:00:20 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:64581 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114AbYCTSAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 14:00:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=d5uegYt4SNOtyKVEcAbVkNfkud9zG5Knj/jc3J6pxUyewG5uIcLp0uHBusGEnC+8FO5fQIxk17h+KS+Mql5ahMChs/Q0UN5AGcnbs+xQw2eMVyiYE3f/0vWidn3wpMLEbjt1gw4kSvOiwKjwezwi7EYgr9kTcSHGitoMrIKW5y0=
Message-ID: <86802c440803201100tb875b94m43d26506226097ba@mail.gmail.com>
Date: Thu, 20 Mar 2008 11:00:18 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Glauber Costa" <gcosta@redhat.com>
Subject: Re: [PATCH 58/79] [PATCH] include mach_apic.h in smpboot_64.c and smpboot.c
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu, ak@suse.de
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
>
>  Is this related to your problem anyhow? (just in curiosity)

No

YH
