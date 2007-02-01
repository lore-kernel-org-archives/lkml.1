Return-Path: <linux-kernel-owner+w=401wt.eu-S1030576AbXBAPLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030576AbXBAPLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 10:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030579AbXBAPLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 10:11:19 -0500
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:25183 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030576AbXBAPLS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 10:11:18 -0500
DomainKey-Signature: s=smtpout; d=dell.com; c=nofws; q=dns; b=ZwbAuzIY75M0/m4pmV6NCZ34F9x+ceIEGxYK/wmbVzI328oYwQKmXDzNhq9bPzu4skKn7owttEhki2z6g+L+kHzBrJ2IKGVbwY2wPIkwEzj1wY5DeJ8lEYI63NtDVzZa;
X-IronPort-AV: i="4.13,267,1167631200"; 
   d="scan'208"; a="179608301:sNHT34969959"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.16.16 Lost CD-ROM Drive
Date: Thu, 1 Feb 2007 09:11:11 -0600
Message-ID: <99CB33592628174AA5F382517D6FCBD3014ED789@ausx3mpc109.aus.amer.dell.com>
In-Reply-To: <1170342315.3984.12.camel@ripley>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.16.16 Lost CD-ROM Drive
Thread-Index: AcdGEndBoMWKHCJDTLScVSR3VgAZtAAAE2Lw
From: <Rogelio_Noriega@Dell.com>
To: <jeremy@emperorlinux.com>, <brian@visionpro.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-precision@lists.us.dell.com>
X-OriginalArrivalTime: 01 Feb 2007 15:11:12.0118 (UTC) FILETIME=[359D6960:01C74613]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I think Jeremy is on the right track what worked for me on a M70 and M90
is adding "hda=noprobe" on the kernel commandline or in grub.

Roger  

-----Original Message-----
From: linux-precision-bounces@dell.com
[mailto:linux-precision-bounces@dell.com] On Behalf Of Jeremy L. Moles
Sent: Thursday, February 01, 2007 9:05 AM
To: Brian D. McGrew
Cc: linux-kernel@vger.kernel.org; linux-precision-Lists
Subject: Re: 2.6.16.16 Lost CD-ROM Drive

On Thu, 2007-02-01 at 07:00 -0800, Brian D. McGrew wrote:
> Hey guys-
> 
> Have a Precision workstation with SATA hard drive and SATA CD-ROM.  If

> I load Fedora Core 5 with a stock 2.6.15 kernel, life is good.
> 
> However, I need to use 2.6.16.16.  Once I build and install this 
> kernel, my CD-ROM drive is gone.  There is a log entry in dmesg that 
> says "ATAPI not support.  Ignoring."
> 
> If I go into the BIOS and set the SATA operations to Legacy/Compatible

> then everything is fine.  I've rebuilt this kernel about 100 times 
> trying everything I can think of.
> 
> When I have SATA set to legacy, the HDD and CD are detected as 
> /dev/hd* and when they're set to SATA Normal operation the HDD is 
> detected as /dev/sda.  If I boot my old 2.6.15 (stock install) kernel 
> then the CD is found as /dev/sdc.
> 
> I've even tried taking the installation default configuration file for

> the 2.6.15 kernel and just wholesale copying it into my 2.6.16.16 
> kernel and build that way but still no go.
> 
> What am I missing to get the 2.6.16.16 kernel to see a SATA CD-ROM 
> drive in normal, non-legacy move?

Try booting 2.6.16 with the following options:

libata.atapi_enabled=1 ide0=noprobe ide1=noprobe

> -brian
> 
> Brian D. McGrew        { brian@visionpro.com ||
> brian@doubledimension.com }
> --
> > Do not read this email while waxing that cat! 
> 
> _______________________________________________
> Linux-Precision mailing list
> Linux-Precision@dell.com
> http://lists.us.dell.com/mailman/listinfo/linux-precision
> Please read the FAQ at http://lists.us.dell.com/faq or search the list

> archives at http://lists.us.dell.com/htdig/
> 

_______________________________________________
Linux-Precision mailing list
Linux-Precision@dell.com
http://lists.us.dell.com/mailman/listinfo/linux-precision
Please read the FAQ at http://lists.us.dell.com/faq or search the list
archives at http://lists.us.dell.com/htdig/
