Return-Path: <linux-kernel-owner+w=401wt.eu-S933083AbYD3Tzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083AbYD3Tzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 15:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758772AbYD3Tzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 15:55:46 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:32982 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756884AbYD3Tzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 15:55:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ijbLv+UqpvLWMqAEHdsFPcQnmI6wzRSpgdKbxssvx0mYsXWaRB3cw7kpTwA2lmKBDIFtjBMK6Ax9Sz7bFLg/Cv5q0x4yl1CIzKxmFlOhokUruVAl4FtFFUCw5lHz0XVpBKjtTENo5QOZvqt3vyk1KCa/zodfU+bb4qbH0lDhA5Y=
From: Balaji Rao <balajirrao@gmail.com>
Organization: National Institute of Technology Karnataka
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: IDE probe failure in 2.6.25-mm1
Date: Thu, 1 May 2008 01:25:35 +0530
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <200804302343.14949.balajirrao@gmail.com> <20080430112028.ae20df4a.akpm@linux-foundation.org> <200804302130.44894.bzolnier@gmail.com>
In-Reply-To: <200804302130.44894.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805010125.36065.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 May 2008 01:00:44 am Bartlomiej Zolnierkiewicz wrote:
> On Wednesday 30 April 2008, Andrew Morton wrote:
> > On Wed, 30 Apr 2008 23:43:14 +0530
> > Balaji Rao <balajirrao@gmail.com> wrote:
> > 
> > > Hi Andrew,
> > > 
> > > IDE probe fails in 2.6.25-mm1 on qemu.
> > > 
> > > [    0.664164] Uniform Multi-Platform E-IDE driver
> > > [    1.571508] ide0: DISABLED, NO IRQ
> > > [    1.572380] ide0: failed to initialize IDE interface
> > > 
> > > This is the output with linux-2.6.git
> > > 
> > > [    1.567368] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> > > [    1.571430] hda: max request size: 512KiB
> > > [    1.574302] hda: 10485760 sectors (5368 MB) w/256KiB Cache, CHS=10402/255/63
> > > [    1.583896] hda: cache flushes supported
> > > [    1.585053]  hda: hda1
> > > 
> > > This is apparently due to the invasive changes in hwif_t's io_ports member.
> > > 
> > 
> > OK, thanks.
> > 
> > I _think_ Bart idenfitied a patch which caused this (or something like it)
> > and dropped it?
> 
> Yep.
> 
> Two patches were dropped from IDE tree:
> 
> 	ide-fix-hwif-s-initialization.patch
> 	ide-make-ide_hwifs-static.patch
> 
> there is also a hot-fix patch available: 
> 
> 	http://article.gmane.org/gmane.linux.ide/30860
> 
> + for qemu switching to using piix host driver (qemu emulates PIIX3) should
> also workaround the issue since it seems to happen only with ide_generic.

Hi Bart,

Yea, it now works in qemu after enabling the PIIX drivers.

Thank you.

-- 
Warm Regards,

Balaji Rao
Dept. of Mechanical Engineering
NITK
