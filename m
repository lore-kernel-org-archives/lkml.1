Return-Path: <linux-kernel-owner+w=401wt.eu-S935809AbXHHFhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935809AbXHHFhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 01:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbXHHFhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 01:37:42 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:18946 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156AbXHHFhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 01:37:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=clzoWK/TiTkyKa5lNM5eFAKpc10v10WjjPLKioX/6cGjMkC7Daz6h8e2u3/uLurOVx+Sy6SJR3SNdA+vcccq5zCabW0sy+x+pt2xZymV80gjljcqpL4bH4dW/+UZ8Db5Jv7vBvQaHa9wYq0aVd/rb55SZX7UeeFg5o3lcyToCzY=
Message-ID: <a8e1da0708072237m615bc472l188e771442579c16@mail.gmail.com>
Date: Wed, 8 Aug 2007 13:37:40 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: i386: kernel boot fail at check_irq_resend:69
Cc: "Li Yang-r58472" <LeoLi@freescale.com>, hpa@zytor.com,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <46B908DE.7030602@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.s/gpFOoJ8PMyPpXRJ4FrnAalSPA@ifi.uio.no>
	 <fa.wDaJQAUs/L/XQkqGZHHUpRgZzvg@ifi.uio.no>
	 <fa.Jxf3sOqjIQoBfp5keWQZ/p/XSd0@ifi.uio.no> <46B908DE.7030602@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>On 8/8/07, Robert Hancock <hancockr@shaw.ca> wrote:
> Dave Young wrote:
> >> On 8/7/07, Li Yang-r58472 <LeoLi@freescale.com> wrote:
> >>   -----Original Message-----
> >>> From: linux-kernel-owner@vger.kernel.org
> >>> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Dave Young
> >>> Sent: Tuesday, August 07, 2007 2:32 PM
> >>> To: hpa@zytor.com
> >>> Cc: LKML
> >>> Subject: i386: kernel boot fail at check_irq_resend:69
> >>>
> >>> Hi,
> >>> The kernerl 2.6.23-rc1-mm2 boot fail at check_irq_resend:69
> >>>        > if (WARN_ON_ONCE(desc->handle_irq != handle_edge_irq))
> >>>        >        return;
> >> Failed?  It's just a kernel Badness for me, and the boot can be finished.
> >
> > No, my kernel panic after this. noapic does not help too.
> > Regards
> > dave
>
> That warning should not cause a panic. Is there another message after it?
>
Yes, The timer set failed, but I think the problem maybe caused by my
wrong lpj command line parameter. If this is true, please just excuse
me for noise.

before the warning:
MP-BIOS bug : 8254 timer not connected to IO-APIC
trying to setup timer(IRQ0) through the 8259A ... failed
trying to setup timer as Virtual Wire IRQ ... failed
trying to setup timer as ExtINT IRQ

after the warning:
failed :

kernel panic - not syncing:
IO-APIC + timer doesn't work!
