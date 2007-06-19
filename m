Return-Path: <linux-kernel-owner+w=401wt.eu-S1758796AbXFSMvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796AbXFSMvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 08:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756643AbXFSMv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 08:51:29 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:54276 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756260AbXFSMv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 08:51:28 -0400
Date: Tue, 19 Jun 2007 14:51:25 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Christoph Hellwig <hch@lst.de>
cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       Jens Axboe <axboe@kernel.dk>,
       "James E.J. Bottomley" <James.Bottomley@SteelEye.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/6] ps3: Disk Storage Driver
In-Reply-To: <20070619054324.GA18542@lst.de>
Message-ID: <Pine.LNX.4.62.0706191450120.4069@pademelon.sonytel.be>
References: <20070615113919.142332000@pademelon.sonytel.be>
 <20070615120848.352093000@pademelon.sonytel.be> <20070619054324.GA18542@lst.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-1258837334-1182257485=:4069"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-1258837334-1182257485=:4069
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 19 Jun 2007, Christoph Hellwig wrote:
> On Fri, Jun 15, 2007 at 01:39:23PM +0200, Geert Uytterhoeven wrote:
> > From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> > 
> > Add a Disk Storage Driver for the PS3:
> >   - Implemented as a block device driver with a dynamic major
> >   - Disk names (and partitions) are of the format ps3d%c(%u)
> >   - Uses software scatter-gather with a 64 KiB bounce buffer as the hypervisor
> >     doesn't support scatter-gather
> 
> Looks good to me.  Only nitpicks are:
> 
>  - ps3disk_priv should probably be an inline function instead of a macro

I used a macro because you can do

    ps3disk_pri(dev) = ...;

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
---584337861-1258837334-1182257485=:4069--
