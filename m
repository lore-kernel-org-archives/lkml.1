Return-Path: <linux-kernel-owner+w=401wt.eu-S933012AbXCMK51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012AbXCMK51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 06:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932282AbXCMK51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 06:57:27 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:35139 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbXCMK50 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 06:57:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=GHbZMxPjjKpFaNuBOAshFu6SFvju0IuPb0k8NAkBrwN979zxemi8pnm4YDtvry7vjA1anLRfXLitU/2lRbIcHep6gF0BL76ZnVcRK7uVqVioJNkAEj+bF2iFBPvuHVACTS+0N1jG3XxgUSmEo0OxN3nHuhH2qkdUuCWmx565YMg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Frank van Maarseveen <frankvm@frankvm.com>
Subject: Re: 2.6.20*: PATA DMA timeout, hangs (2)
Date: Tue, 13 Mar 2007 12:04:31 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <20070312085447.GA10955@janus> <200703122140.25682.bzolnier@gmail.com> <20070313091936.GA23765@janus>
In-Reply-To: <20070313091936.GA23765@janus>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703131204.31435.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 13 March 2007, Frank van Maarseveen wrote:
> On Mon, Mar 12, 2007 at 09:40:25PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > 
> > Hi,
> > 
> > On Monday 12 March 2007, Frank van Maarseveen wrote:
> > > On Mon, Mar 12, 2007 at 01:21:18PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > > > 
> > > > Hi,
> > > > 
> > > > Could you check if this is the same problem as this one:
> > > > 
> > > > http://bugzilla.kernel.org/show_bug.cgi?id=8169
> > > 
> > > Looks like it except that I don't see "lost interrupt" messages here. So,
> > > it might be something different (I don't know).
> > 
> > From the first mail:
> > 
> > hda: max request size: 128KiB
> > hda: 40021632 sectors (20491 MB) w/2048KiB Cache, CHS=39704/16/63
> > hda: cache flushes not supported
> >  hda: hda1 hda2 hda4
> > 
> > It seems that DMA is not used by default (CONFIG_IDEDMA_PCI_AUTO=n),
> > so this is probably exactly the same issue.
> > 
> > Please try the patch attached to the bugzilla bug entry.
> 
> 2.6.20.2 rejects this patch and I don't see a way to apply it by hand:
> ide_set_dma() isn't there, nothing seems to match.

The patch is for 2.6.21-rc3, sorry for not making it clear.

Bart
