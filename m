Return-Path: <linux-kernel-owner+w=401wt.eu-S1761254AbYHHVNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761254AbYHHVNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 17:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755594AbYHHVNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:13:32 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:58694 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191AbYHHVNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:13:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Xt/2OfahQSby6uYW0+6dfg53G56FWK/ueQzz17pKkij5A57cGfj47T3JVZvuSNW4a3
         VWTfHj7rfzvHpb3Mot7fE2xF0HKdveYy0STU9ZDrYePBhrS0bZATNxf/SVydav1MXLmV
         DTb/RnrlLje7wij7zSwQ04oCIydFavAB+v0r8=
Message-ID: <86802c440808081413u2249fff1g1940ff472cdf10e7@mail.gmail.com>
Date: Fri, 8 Aug 2008 14:13:29 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: + x86-kill-arch-x86-kernel-mpparsec-debugging-printk.patch added to -mm tree
Cc: mm-commits@vger.kernel.org, rene.herman@keyaccess.nl,
       rene.herman@gmail.com
In-Reply-To: <200808082051.m78KpZGC027833@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200808082051.m78KpZGC027833@imap1.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 8, 2008 at 1:51 PM,  <akpm@linux-foundation.org> wrote:
>
> The patch titled
>     x86: kill arch/x86/kernel/mpparse.c debugging printk
> has been added to the -mm tree.  Its filename is
>     x86-kill-arch-x86-kernel-mpparsec-debugging-printk.patch
>
> Before you just go and hit "reply", please:
>   a) Consider who else should be cc'ed
>   b) Prefer to cc a suitable mailing list as well
>   c) Ideally: find the original patch on the mailing list and do a
>      reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
>
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
>
> ------------------------------------------------------
> Subject: x86: kill arch/x86/kernel/mpparse.c debugging printk
> From: Rene Herman <rene.herman@keyaccess.nl>
>
> commit 11a62a056093a7f25f1595fbd8bd5f93559572b6 turns some formerly nopped
> debugging printks in arch/x86/kernel/mppparse.c into regular ones.  The
> one at the top of smp_scan_config() in particular also prints on
> !CONFIG_SMP/CONFIG_X86_LOCAL_APIC kernels and UP machines without anything
> resembling MP tables which makes their lowly UP owners wonder...
>
> Given that it was up to this point also not considered valuable user-level
> information, let's just kill that one.
>
> Signed-off-by: Rene Herman <rene.herman@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  arch/x86/kernel/mpparse.c |    1 -
>  1 file changed, 1 deletion(-)
>
> diff -puN arch/x86/kernel/mpparse.c~x86-kill-arch-x86-kernel-mpparsec-debugging-printk arch/x86/kernel/mpparse.c
> --- a/arch/x86/kernel/mpparse.c~x86-kill-arch-x86-kernel-mpparsec-debugging-printk
> +++ a/arch/x86/kernel/mpparse.c
> @@ -697,7 +697,6 @@ static int __init smp_scan_config(unsign
>        unsigned int *bp = phys_to_virt(base);
>        struct intel_mp_floating *mpf;
>
> -       printk(KERN_DEBUG "Scan SMP from %p for %ld bytes.\n", bp, length);
>        BUILD_BUG_ON(sizeof(*mpf) != 16);
>
>        while (length > 0) {
> _
>
> Patches currently in -mm which might be from rene.herman@keyaccess.nl are
>
> x86-kill-arch-x86-kernel-mpparsec-debugging-printk.patch
> i2c-dont-autograb-i2c-pca-is.patch
>
why?  that just three lines debug debug info.

YH
