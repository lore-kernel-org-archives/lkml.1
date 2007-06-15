Return-Path: <linux-kernel-owner+w=401wt.eu-S1756985AbXFOSFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985AbXFOSFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 14:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756783AbXFOSFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 14:05:11 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:52785 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756755AbXFOSFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 14:05:08 -0400
Date: Fri, 15 Jun 2007 20:05:05 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Jens Axboe <axboe@kernel.dk>,
       "James E.J. Bottomley" <James.Bottomley@SteelEye.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [patch 4/6] ps3: Disk Storage Driver
In-Reply-To: <20070615171545.316dfac7@the-village.bc.nu>
Message-ID: <Pine.LNX.4.62.0706152004090.15507@pademelon.sonytel.be>
References: <20070615113919.142332000@pademelon.sonytel.be>
 <20070615120848.352093000@pademelon.sonytel.be> <1181918159.25228.543.camel@pmac.infradead.org>
 <Pine.LNX.4.62.0706151642010.8248@pademelon.sonytel.be>
 <20070615171545.316dfac7@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-1688040106-1181930705=:15507"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-1688040106-1181930705=:15507
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 15 Jun 2007, Alan Cox wrote:
> > > Any particular reason why this is done as a separate block device driver
> > > rather than as SCSI?
> > 
> > Because no new fake SCSI drivers are accepted anymore.
> 
> Where did drivers/ata come from ;)

I was told that one got in just before the moratorium on fake SCSI.

> How about making it a fake ata driver if James is being fussy 8)

I don't think Christoph likes fake ATA drivers neither ;-)

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
---584337861-1688040106-1181930705=:15507--
