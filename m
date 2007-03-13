Return-Path: <linux-kernel-owner+w=401wt.eu-S965453AbXCMJTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965453AbXCMJTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 05:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965607AbXCMJTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 05:19:38 -0400
Received: from frankvm.xs4all.nl ([80.126.170.174]:58114 "EHLO
	janus.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965453AbXCMJTh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 05:19:37 -0400
Date: Tue, 13 Mar 2007 10:19:36 +0100
From: Frank van Maarseveen <frankvm@frankvm.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20*: PATA DMA timeout, hangs (2)
Message-ID: <20070313091936.GA23765@janus>
References: <20070312085447.GA10955@janus> <200703121321.18299.bzolnier@gmail.com> <20070312124007.GB12265@janus> <200703122140.25682.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <200703122140.25682.bzolnier@gmail.com>
User-Agent: Mutt/1.4.1i
X-BotBait: val@frankvm.com, kuil@frankvm.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 09:40:25PM +0100, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Monday 12 March 2007, Frank van Maarseveen wrote:
> > On Mon, Mar 12, 2007 at 01:21:18PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > > 
> > > Hi,
> > > 
> > > Could you check if this is the same problem as this one:
> > > 
> > > http://bugzilla.kernel.org/show_bug.cgi?id=8169
> > 
> > Looks like it except that I don't see "lost interrupt" messages here. So,
> > it might be something different (I don't know).
> 
> From the first mail:
> 
> hda: max request size: 128KiB
> hda: 40021632 sectors (20491 MB) w/2048KiB Cache, CHS=39704/16/63
> hda: cache flushes not supported
>  hda: hda1 hda2 hda4
> 
> It seems that DMA is not used by default (CONFIG_IDEDMA_PCI_AUTO=n),
> so this is probably exactly the same issue.
> 
> Please try the patch attached to the bugzilla bug entry.

2.6.20.2 rejects this patch and I don't see a way to apply it by hand:
ide_set_dma() isn't there, nothing seems to match.

-- 
Frank
