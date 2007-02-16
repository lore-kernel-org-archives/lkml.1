Return-Path: <linux-kernel-owner+w=401wt.eu-S966268AbXBPJly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966268AbXBPJly (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 04:41:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966271AbXBPJly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 04:41:54 -0500
Received: from wr-out-0506.google.com ([64.233.184.225]:62718 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966268AbXBPJlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 04:41:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=udlmT5ZRIJZ5u7LIM6/B+GqN+X8JzXOws8aZbVQGtiKYJv0pbzXVeyOVfYSPHbfAB/0jlv5OIjnSC1VYANmbfhcAZPAEwsZZx0fAeT4plwHAljUj/3uqiuBFU1rU8VIS8kzBQbm0++JPHG6QFLjX2JiGPTdj26PSZXGkhU9IPvg=
Message-ID: <32209efe0702160141k32f16923qdf93abdf5d473886@mail.gmail.com>
Date: Fri, 16 Feb 2007 02:41:51 -0700
From: "Natalie Protasevich" <protasnb@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: FW: [PATCH] i386: irq: Kill IRQ compression
Cc: lenb@kernel.org, "Andi Kleen" <ak@suse.de>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
In-Reply-To: <19D0D50E9B1D0A40A9F0323DBFA04ACC023B0E21@USRV-EXCH4.na.uis.unisys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19D0D50E9B1D0A40A9F0323DBFA04ACC023B0E21@USRV-EXCH4.na.uis.unisys.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

l> From: Eric W. Biederman [mailto:ebiederm@xmission.com]
> Sent: Friday, February 16, 2007 2:22 AM
> To: Protasevich, Natalie
> Cc: Len Brown; Andi Kleen; lkml - Kernel Mailing List;
> linux-acpi@vger.kernel.org
> Subject: Re: [PATCH] i386: irq: Kill IRQ compression
>
> ebiederm@xmission.com (Eric W. Biederman) writes:
>
> > By itself I don't think we are going to observe any real problems
> > with this patch.
> >
> > However if we are going to be serious about this we need to do a
> > few more things.
> >
> > - kill ioapic_renumber_irq.
>
> Looking closer ioapic_renumber_irq does not appear to be an irq
> compress thing.  Rather it appears to be a work around for a weird
> acpi implementation where gsi 0 - 15 are not the ISA irqs.
>
> Natalie is my reading of the code there correct?

Yes, indeed.

>
> If so keeping ioapic_renumber_irq makes sense.  Although giving
> it a name that suggests it is working around weird implementation
> details would be good.

Sure. I think it was originally renumber_gsi something, but Len had to
change it so it sounds more explicit as familiar "IRQ".
--Natalie
>
> Eric
>
