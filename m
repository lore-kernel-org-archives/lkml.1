Return-Path: <linux-kernel-owner+w=401wt.eu-S1762974AbXIUULS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762974AbXIUULS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757230AbXIUULK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:11:10 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:7944 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbXIUULJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:11:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Vc1St6bpDf1KUeroFw8PTzQEjHibGC7DywumWHyYWCDBWzmiNRCH1+4YRyDzNswr4p/BpjidVoy0+6amkAhk029BahD84hInvXTS6vgKnEzWNpEDakkEnRP7JxP/PsS6oTMV5r/ETSQmQ0I48/1xY+Kzht2I1/VnFmCgj7vchqA=
Message-ID: <f870da180709211311r7e8da305x293214175098205a@mail.gmail.com>
Date: Fri, 21 Sep 2007 22:11:08 +0200
From: "Mike Rapoport" <mike.rapoport@gmail.com>
To: me <mike@compulab.co.il>
Subject: Re: [PATCH 02/03] CM-x270: ITE 8152 PCI bridge support
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.63.0709211240570.9343@pcgl.dsa-ac.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46F29A0A.4000407@compulab.co.il>
	 <Pine.LNX.4.63.0709211240570.9343@pcgl.dsa-ac.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/21/07, Guennadi Liakhovetski <gl@dsa-ac.de> wrote:
> On Thu, 20 Sep 2007, Mike Rapoport wrote:
>
> > This patch provides driver for ITE 8152 PCI bridge.
> >
> > Signed-off-by: Mike Rapoport <mike@compulab.co.il>
> >
> >  arch/arm/common/Makefile          |    1 +
> >  arch/arm/common/it8152.c          |  387 +++++++++++++++++++++++++++++++++++++
>
> Shouldn't it go to drivers/pci and define a platform driver? it8152 is not
> an ARM specific controller.

ITE 8152 is StrongArm and PXA255 companion chip. I can hardly imagine
it's use with other architectures. Even making it work with PXA270 was
pretty tough.

>
> Thanks
> Guennadi
> ---------------------------------
> Guennadi Liakhovetski, Ph.D.
> DSA Daten- und Systemtechnik GmbH
> Pascalstr. 28
> D-52076 Aachen
> Germany
>
> -------------------------------------------------------------------
> List admin: http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel
> FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
> Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php
>



-- 
Sincerely Yours,
Mike.
