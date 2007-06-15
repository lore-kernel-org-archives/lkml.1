Return-Path: <linux-kernel-owner+w=401wt.eu-S1755444AbXFOOnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbXFOOnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 10:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596AbXFOOnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 10:43:09 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:51163 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753373AbXFOOnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 10:43:08 -0400
Date: Fri, 15 Jun 2007 16:43:05 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: David Woodhouse <dwmw2@infradead.org>
cc: Jens Axboe <axboe@kernel.dk>,
       "James E.J. Bottomley" <James.Bottomley@SteelEye.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>
Subject: Re: [patch 4/6] ps3: Disk Storage Driver
In-Reply-To: <1181918159.25228.543.camel@pmac.infradead.org>
Message-ID: <Pine.LNX.4.62.0706151642010.8248@pademelon.sonytel.be>
References: <20070615113919.142332000@pademelon.sonytel.be>
 <20070615120848.352093000@pademelon.sonytel.be> <1181918159.25228.543.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-1219061913-1181918585=:8248"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-1219061913-1181918585=:8248
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 15 Jun 2007, David Woodhouse wrote:
> On Fri, 2007-06-15 at 13:39 +0200, Geert Uytterhoeven wrote:
> > Add a Disk Storage Driver for the PS3:
> >   - Implemented as a block device driver with a dynamic major
> >   - Disk names (and partitions) are of the format ps3d%c(%u)
> >   - Uses software scatter-gather with a 64 KiB bounce buffer as the hypervisor
> >     doesn't support scatter-gather
> 
> Any particular reason why this is done as a separate block device driver
> rather than as SCSI?

Because no new fake SCSI drivers are accepted anymore.

With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584337861-1219061913-1181918585=:8248--
