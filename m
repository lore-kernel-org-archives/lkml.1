Return-Path: <linux-kernel-owner+w=401wt.eu-S1763532AbYGABPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763532AbYGABPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 21:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755942AbYGABO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 21:14:56 -0400
Received: from mailtp.via.com.tw ([61.66.243.2]:22837 "EHLO mailtp.via.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755090AbYGABO4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 21:14:56 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 9/13] viafb: Makefile, share.h
Date: Tue, 1 Jul 2008 09:14:52 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB8074E7CF3@exchtp03.taipei.via.com.tw>
In-Reply-To: <20080630104753.GA16040@uranus.ravnborg.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 9/13] viafb: Makefile, share.h
Thread-Index: AcjanqhWvaHhkCkzSu6e+ZaQNDuFFgAeSl5A
From: <JosephChan@via.com.tw>
To: <sam@ravnborg.org>
Cc: <linux-fbdev-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>, <geert@linux-m68k.org>
X-OriginalArrivalTime: 01 Jul 2008 01:14:54.0690 (UTC) FILETIME=[DEB08420:01C8DB17]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam,

Got that, Thanks.

BRs,
Joseph Chan 
-----Original Message-----
From: Sam Ravnborg [mailto:sam@ravnborg.org] 
Sent: Monday, June 30, 2008 6:48 PM
To: Joseph Chan
Cc: linux-fbdev-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org; akpm@linux-foundation.org; geert@linux-m68k.org
Subject: Re: [PATCH 9/13] viafb: Makefile, share.h

On Mon, Jun 30, 2008 at 03:38:52PM +0800, JosephChan@via.com.tw wrote:
> Makefile for drivers/video/via/
> share.h: shared macro for viafb
> 
> 
> Signed-off-by: Joseph Chan <josephchan@via.com.tw>
> 
> diff -Nur a/drivers/video/via/Makefile b/drivers/video/via/Makefile
> --- a/drivers/video/via/Makefile	1970-01-01 08:00:00.000000000 +0800
> +++ b/drivers/video/via/Makefile	2008-06-30 08:53:33.000000000 +0800
> @@ -0,0 +1,9 @@
> +#
> +# Makefile for the VIA framebuffer driver (for Linux Kernel 2.6) #
> +                                                                                
> +obj-$(CONFIG_FB_VIA) += viafb.o
> +
> +viafb-y	:=viafbdev.o hw.o iface.o  via_i2c.o dvi.o lcd.o ioctl.o accel.o via_utility.o vt1636.o global.o tblDPASetting.o viamode.o tbl1636.o
> +
> +viafb-objs	:=	$(viafb-y)

This assignmnet is not needed - please drop it.
kbuild already understands <modulename>-y

	Sam

