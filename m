Return-Path: <linux-kernel-owner+w=401wt.eu-S1765371AbXJTMXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765371AbXJTMXR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 08:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753911AbXJTMXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 08:23:01 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:38871 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702AbXJTMXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 08:23:00 -0400
From: Nick Warne <nick@ukfsn.org>
Reply-To: nick@ukfsn.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: New CD/DVD drive - 80-wire cable detection failure
Date: Sat, 20 Oct 2007 13:22:57 +0100
User-Agent: KMail/1.9.7
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <200710181832.42906.nick@ukfsn.org> <200710200028.21860.bzolnier@gmail.com> <200710201037.31283.nick@ukfsn.org>
In-Reply-To: <200710201037.31283.nick@ukfsn.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710201322.57178.nick@ukfsn.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

SOLVED!

On Saturday 20 October 2007 10:37:31 Nick Warne wrote:
> On Friday 19 October 2007 23:28:21 Bartlomiej Zolnierkiewicz wrote:
> > On Saturday 20 October 2007, Nick Warne wrote:
> > > On Friday 19 October 2007 22:44:27 Bartlomiej Zolnierkiewicz wrote:
> > >
> > > hdparm -I
> >
> > It should have been hdparm --Istdout (sorry, once again).
>
> hdparm --Istdout /dev/hdd

I built a new kernel today 2.6.23.1, and looked very closely at kernel 
options.

Setting:

CONFIG_IDEDMA_IVB

did the trick!

hdd: TSSTcorp CDDVDW SH-S202J, ATAPI CD/DVD-ROM drive
hdd: selected mode 0x44
hdd: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache, UDMA(66)

Thank you all for looking at this non-issue.  Sorry for the noise!!!

Nick

>
> There is some confusion on this drive now.  Somebody sent me a link to tech
> specs and that states it only does udma2 mode - but the specs I found state
> it does udma4?
>
> http://downloadcenter.samsung.com/content/UM/200708/20070823084759796_SH-S2
>02J_ENG.pdf
>
> So knowing what these hardware firms are like, maybe it _is_ only udma2?
>
> Thanks,
>
> Nick



-- 
Free Software Foundation Associate Member 5508
