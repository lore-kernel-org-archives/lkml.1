Return-Path: <linux-kernel-owner+w=401wt.eu-S932781AbXGMNed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781AbXGMNed (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 09:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758940AbXGMNeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 09:34:21 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:48366 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758374AbXGMNeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 09:34:20 -0400
Date: Fri, 13 Jul 2007 15:34:18 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Olaf Hering <olaf@aepfle.de>
cc: Paul Mackerras <paulus@samba.org>, Jens Axboe <axboe@kernel.dk>,
       "James E.J. Bottomley" <James.Bottomley@SteelEye.com>,
       Alessandro Rubini <rubini@vision.unipv.it>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: PS3 Storage Driver O_DIRECT issue
In-Reply-To: <20070713122752.GA854@aepfle.de>
Message-ID: <Pine.LNX.4.62.0707131532350.18802@pademelon.sonytel.be>
References: <20070704132212.726923000@pademelon.sonytel.be>
 <20070713122752.GA854@aepfle.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-1147011636-1184333658=:18802"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-1147011636-1184333658=:18802
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 13 Jul 2007, Olaf Hering wrote:
> This driver (or the generic PS3 code) has appearently problems with
> O_DIRECT. 
> glibc aborts parted because the malloc metadata get corrupted. While it
> is reproducible, the place where it crashes changes with every version
> of the debug attempt.
> I dont have a handle right now, all I know is that the metadata after a
> malloc area get overwritten with zeros.
> 
> 
> Can you have a look at this? 
> parted /dev/ps3da
> print (a few times)

I can't seem to reproduce this with parted 1.7.1-5.1 (from Debian
etch/lenny/sid) and kernel 2.6.22-g77320894.

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
---584337861-1147011636-1184333658=:18802--
