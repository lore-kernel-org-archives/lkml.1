Return-Path: <linux-kernel-owner+w=401wt.eu-S1760390AbYG2Wmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760390AbYG2Wmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 18:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756856AbYG2Wm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 18:42:29 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:30016 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755769AbYG2Wm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 18:42:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=tzH10Tc32uawyzrBmDwDyGxa7mlP+cURyxvrNqJzSxO3wUFuBtMJvyPxeXR4p+sorM
         JsUTyj8i5S7t2IaIr6CZiAcJE5QIJ1Rxy7vZoWQPiCeKO+XMh18UKxLB5UvryomA4fa3
         8aERUpX6C3mWhhWGFJgrZEHuLqGS1eSg6zJpo=
Date: Wed, 30 Jul 2008 00:40:49 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: Grant Coady <gcoady.lk@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux v2.6.27-rc1: fails to compile
Message-ID: <20080729224049.GA7325@slug>
References: <alpine.LFD.1.10.0807281956030.3334@nehalem.linux-foundation.org> <g54v84t6rgqplte4tvjrlh4r8g3m6n8kms@4ax.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <g54v84t6rgqplte4tvjrlh4r8g3m6n8kms@4ax.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Grant,
On Wed, Jul 30, 2008 at 08:03:42AM +1000, Grant Coady wrote:
> On Mon, 28 Jul 2008 20:23:21 -0700 (PDT), Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> >
> >It's two weeks (and one day), and the merge window is over.
> >
> >Finally. I don't know why, but this one really did feel pretty dang busy. 
> >And the size of the -rc1 patch bears that out - at 12MB, it's about 50% 
> >bigger than 26-rc1 (but not that much bigger than 24/25-rc1, so it's not 
> >like it's anything unheard of).
> 
> Couple machines failed to compile with same error in different place:
> 
>   CC      arch/x86/kernel/acpi/cstate.o
> arch/x86/kernel/acpi/cstate.c: In function `acpi_processor_ffh_cstate_probe':
> arch/x86/kernel/acpi/cstate.c:94: error: invalid lvalue in unary `&'
> make[2]: *** [arch/x86/kernel/acpi/cstate.o] Error 1
> make[1]: *** [arch/x86/kernel/acpi] Error 2
> make: *** [arch/x86/kernel] Error 2
> grant@peetoo:~/linux/linux-2.6.27-rc1a$
> 
This issue has been reported, this is due to your old compiler.
Fix here:
http://lkml.org/lkml/2008/7/29/48

Regards,
Frederik
