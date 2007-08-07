Return-Path: <linux-kernel-owner+w=401wt.eu-S1759501AbXHGJDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501AbXHGJDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 05:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757069AbXHGJCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 05:02:53 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:53399 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233AbXHGJCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 05:02:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Iy2pS9AJDTdSId6Qwmee0FEo9E799/OhWo2g12WDTnSogptMJdIIwnV72QPnolMv+UVvnUUUTDOAEUamOt4JJ5eIc67u7lF+SqV807SoEXOl773RquVn4nCJybWTALZ048CyRR4JsZSqFyFRdo42Jsg40TewHXmXH/tAK/vwp1k=
Message-ID: <a8e1da0708070202r2779664bx41af013e77a95116@mail.gmail.com>
Date: Tue, 7 Aug 2007 09:02:50 +0000
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Li Yang-r58472" <LeoLi@freescale.com>
Subject: Re: i386: kernel boot fail at check_irq_resend:69
Cc: hpa@zytor.com, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <989B956029373F45A0B8AF029708189001190014@zch01exm26.fsl.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0708062332w4492eba9u2085f96fe5aefced@mail.gmail.com>
	 <989B956029373F45A0B8AF029708189001190014@zch01exm26.fsl.freescale.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>On 8/7/07, Li Yang-r58472 <LeoLi@freescale.com> wrote:
>   -----Original Message-----
> > From: linux-kernel-owner@vger.kernel.org
> > [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Dave Young
> > Sent: Tuesday, August 07, 2007 2:32 PM
> > To: hpa@zytor.com
> > Cc: LKML
> > Subject: i386: kernel boot fail at check_irq_resend:69
> >
> > Hi,
> > The kernerl 2.6.23-rc1-mm2 boot fail at check_irq_resend:69
> >        > if (WARN_ON_ONCE(desc->handle_irq != handle_edge_irq))
> >        >        return;
>
> Failed?  It's just a kernel Badness for me, and the boot can be finished.

No, my kernel panic after this. noapic does not help too.
Regards
dave
