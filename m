Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbXLFVZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbXLFVZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 16:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbXLFVZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 16:25:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:50300 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705AbXLFVZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 16:25:34 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch] old debugging hacks sneaked back
Date: Thu, 6 Dec 2007 16:24:58 -0500
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>
References: <20071206085040.GA1642@elf.ucw.cz> <200712062212.48209.rjw@sisk.pl>
In-Reply-To: <200712062212.48209.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712061624.58618.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied.

thanks,
-len

On Thursday 06 December 2007 16:12, Rafael J. Wysocki wrote:
> On Thursday, 6 of December 2007, Pavel Machek wrote:
> > 
> > Old debugging hack sneaked back during x86 merge, this removes it.
> 
> Yeah, good catch, thanks.
> 
> > Signed-off-by: Pavel Machek <pavel@suse.cz>
> 
> Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> > diff --git a/arch/x86/kernel/acpi/wakeup_32.S b/arch/x86/kernel/acpi/wakeup_32.S
> > index a97313b..1e931aa 100644
> > --- a/arch/x86/kernel/acpi/wakeup_32.S
> > +++ b/arch/x86/kernel/acpi/wakeup_32.S
> > @@ -35,10 +35,6 @@ wakeup_code:
> >  	wakeup_code_start = .
> >  	.code16
> >  
> > - 	movw	$0xb800, %ax
> > -	movw	%ax,%fs
> > -	movw	$0x0e00 + 'L', %fs:(0x10)
> > -
> >  	cli
> >  	cld
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
