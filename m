Return-Path: <linux-kernel-owner+w=401wt.eu-S1764224AbXE2J6C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764224AbXE2J6C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 05:58:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbXE2J5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 05:57:54 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:36212 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753603AbXE2J5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 05:57:53 -0400
Date: Tue, 29 May 2007 11:57:52 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Christoph Hellwig <hch@lst.de>
cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 7/7] ps3: FLASH ROM Storage Driver
In-Reply-To: <20070529095355.GA29351@lst.de>
Message-ID: <Pine.LNX.4.62.0705291157260.7698@pademelon.sonytel.be>
References: <20070525083607.784351000@sonycom.com> <20070525083632.815300000@sonycom.com>
 <20070529095355.GA29351@lst.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007, Christoph Hellwig wrote:
> On Fri, May 25, 2007 at 10:36:14AM +0200, Geert.Uytterhoeven@sonycom.com wrote:
> > Add a FLASH ROM Storage Driver for the PS3:
> >   - Implemented as a misc character device driver
> >   - Uses a fixed 256 KiB buffer allocated from boot memory as the hypervisor
> >     requires the writing of aligned 256 KiB blocks
> 
> Looks good, but please either make the driver aware of multiple devices
> even if they can't happen currently, or alternatively error out in
> ->probe if of some reason it's called for a second device.

ps3flash_probe() does return -EBUSY when called for a second device.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
