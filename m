Return-Path: <linux-kernel-owner+w=401wt.eu-S1753378AbZASOlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbZASOlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:41:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbZASOll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:41:41 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:47576 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbZASOlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:41:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=RiRTov2PeXCR04N/7VU3nqdEuGMtS2QrlYW9bkawqF1d0J/Bfnyz1yaa6dOu/v6KL2
         ftFWcRIkbaS8VUpixLNVBTikwiEptEk0+SqvOGQc1AFDBJ+Ujn6DZW0cThibwVeDod2X
         ep16BNX445VS70LXtr4kdmHazLnD9I5POAI9A=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 08/12] ide: remove no longer needed IDE_HFLAG[_FORCE]_LEGACY_IRQS
Date: Mon, 19 Jan 2009 15:41:41 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc1-next-20090116; KDE/4.1.3; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090119141330.27613.34546.sendpatchset@localhost.localdomain> <20090119141443.27613.89085.sendpatchset@localhost.localdomain> <9ea470500901190636g366767bt2b40917b2d2718f9@mail.gmail.com>
In-Reply-To: <9ea470500901190636g366767bt2b40917b2d2718f9@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200901191541.41305.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 January 2009, Borislav Petkov wrote:
> Hi,
> 
> On Mon, Jan 19, 2009 at 3:14 PM, Bartlomiej Zolnierkiewicz
> <bzolnier@gmail.com> wrote:
> 
> [.. ]
> 
> > Index: b/include/linux/ide.h
> > ===================================================================
> > --- a/include/linux/ide.h
> > +++ b/include/linux/ide.h
> > @@ -1347,10 +1347,6 @@ enum {
> >        IDE_HFLAG_ERROR_STOPS_FIFO      = (1 << 19),
> >        /* serialize ports */
> >        IDE_HFLAG_SERIALIZE             = (1 << 20),
> > -       /* use legacy IRQs */
> > -       IDE_HFLAG_LEGACY_IRQS           = (1 << 21),
> > -       /* force use of legacy IRQs */
> > -       IDE_HFLAG_FORCE_LEGACY_IRQS     = (1 << 22),
> >        /* host is TRM290 */
> >        IDE_HFLAG_TRM290                = (1 << 23),
> >        /* use 32-bit I/O ops */
> 
> maybe contigious numbering of the enums here?

I plan to re-use these two flags quite soon for other purposes so I thought
that I may save some time/noise on moving the rest of flags around... :)
