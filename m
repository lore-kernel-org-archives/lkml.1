Return-Path: <linux-kernel-owner+w=401wt.eu-S1758990AbYEQPRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758990AbYEQPRY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 11:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755813AbYEQPRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 11:17:15 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:11569 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbYEQPRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 11:17:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=joUxKawxdBx2Tlpt3JHXizw+dwZJBulRA3jY/xEr62cWCWOpG8ORm39TnRUr114gbNbPjbRZks+txWhtIGDqsdO/YxzhmM4xcD5b0iIxZIjGy5dFDNJJZCW6DMrsiwlX4D4009A+BthNz65QRp+z8IGhXz3NdwlmoD5DSYfFo78=
Message-ID: <84144f020805170817x2c90233an3abc6fce3e9770a6@mail.gmail.com>
Date: Sat, 17 May 2008 18:17:13 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Khem Raj" <raj.khem@gmail.com>
Subject: Re: linux/a.out.h is not exported to userspace
Cc: k.shutemov@gmail.com, linux-kernel@vger.kernel.org,
       "David Woodhouse" <dwmw2@infradead.org>
In-Reply-To: <1210983237.8550.28.camel@isis>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1210983237.8550.28.camel@isis>
X-Google-Sender-Auth: f68da57442ca71a0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding cc)

On Sat, May 17, 2008 at 3:13 AM, Khem Raj <raj.khem@gmail.com> wrote:
> Looking for a compile failure for a package on uclibc system using
> kernel-headers from 2.6.25 I found that linux/a.out.h is no more
> exported to userland anymore.
>
> This commit below has disabled it from being exported. The commit Do not
> export asm/page.h during make headers_install so I was wondering if it
> was intended to unexport linux/a.out.h or not.
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ed7b1889da256977574663689b598d88950bbd23
>
> Looking at the patch from lkml post
>
> http://linux.derkeiler.com/Mailing-Lists/Kernel/2007-10/msg08913.html
>
> second hunk to include/linux/Kbuild was not applied which caused this
> problem.
>
> I think I do not fall into Signed-off-by definition. I tested the
> following patch on 2.6.25.
>
> Thanks
>
> -Khem
>
> Tested-by: Khem Raj <raj.khem@gmail.com>
>
> diff --git a/include/linux/Kbuild b/include/linux/Kbuild
> index b7d81b2..8a3d93e 100644
> --- a/include/linux/Kbuild
> +++ b/include/linux/Kbuild
> @@ -168,6 +168,7 @@ unifdef-y += acct.h
>  unifdef-y += adb.h
>  unifdef-y += adfs_fs.h
>  unifdef-y += agpgart.h
> +unifdef-y += a.out.h
>  unifdef-y += apm_bios.h
>  unifdef-y += atalk.h
>  unifdef-y += atmdev.h

It's usually a good idea to cc the patch author(s) if you want
something fixed....
