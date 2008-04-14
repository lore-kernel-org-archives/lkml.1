Return-Path: <linux-kernel-owner+w=401wt.eu-S933626AbYDNSYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933626AbYDNSYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:24:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933321AbYDNSV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:21:56 -0400
Received: from mailgw1.fraunhofer.de ([153.96.1.17]:21832 "EHLO
	mailgw1.fraunhofer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933313AbYDNSVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:21:54 -0400
Date: Mon, 14 Apr 2008 20:21:30 +0200
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, htejun@gmail.com
Subject: Re: Again... DMA speed too slow
Message-ID: <4803a0aa.MFfq4lGLYeJxd4mH%Joerg.Schilling@fokus.fraunhofer.de>
References: <48038c3e.P3RWjRNXsDrhjIX7%Joerg.Schilling@fokus.fraunhofer.de>
 <20080414175636.4ea815dc@core>
 <48039208.H1ySWf8m1sXKYjHZ%Joerg.Schilling@fokus.fraunhofer.de>
 <20080414182918.4779b8ea@core>
In-Reply-To: <20080414182918.4779b8ea@core>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 14 Apr 2008 18:21:30.0881 (UTC) FILETIME=[5CA8DF10:01C89E5C]
X-Fraunhofer-Email-Policy: accepted
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > OK, I know that a few drives give wrong DMA speed test results on Solaris,
> > so the behavior for these drives seems to be unrelated to the OS.
>
> Controllers don't always get DMA ATAPI right things like that - not
> trivial little speed test details.

Using the term "controller" is not specific enough to understand what you might
like to tell.


> > I am not sure why you mention the term "brave", is it because all known Linux 
> > distributions still require suid root? In this case, I encourage you to inform
>
> Last time I checked almost all cd burning was being done non root.

Looks like you are incorrectly informed in this area or you checked only software 
that does not work correclty in all cases ....

For your information:

Linux traditionally needed suid root for sending SCSI commands until someone 
introduced a bug in late 2.4 kernels. After this bug has been discovered, the 
Linux Kernel interface has been changed in an incomatible way. At the same time,
the Linux kernel started to filter SCSI commands. Some commands that are needed 
for CD/DVD writing still need root privileges, others don't.

Some people did take my working software and removed security checks.
The fact that it is possible to still write CDs under some conditions
does not prove anything. It justs verifies that the people who removed
those checks are not smart enough to find the assignements of the SCSI command
codes in cdrecord ;-)

Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       schilling@fokus.fraunhofer.de     (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/old/private/ ftp://ftp.berlios.de/pub/schily
