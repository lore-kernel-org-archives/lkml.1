Return-Path: <linux-kernel-owner+w=401wt.eu-S1764645AbXEYTgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764645AbXEYTgs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 15:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbXEYTgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 15:36:41 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:45467 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753273AbXEYTgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 15:36:41 -0400
Date: Fri, 25 May 2007 21:36:39 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Arnd Bergmann <arnd@arndb.de>
cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 6/7] ps3: ROM Storage Driver
In-Reply-To: <200705251850.30342.arnd@arndb.de>
Message-ID: <Pine.LNX.4.62.0705252135010.2657@pademelon.sonytel.be>
References: <20070525083607.784351000@sonycom.com> <20070525083632.677742000@sonycom.com>
 <200705251850.30342.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007, Arnd Bergmann wrote:
> On Friday 25 May 2007, Geert.Uytterhoeven@sonycom.com wrote:
> > Add a CD/DVD/BD Storage Driver for the PS3:
> >   - Implemented as a SCSI device driver
> 
> I assume you tried implementing it as a block device driver,
> like you PS3 disk driver does, and failed for some reason.
> 
> What is the problem? Is there infrastructure missing in the
> CD-ROM layer?

As the CD/DVD/BD part just accepts SCSI/ATAPI commands (except for plain
read/write), I was suggested to keep it as a SCSI driver.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
