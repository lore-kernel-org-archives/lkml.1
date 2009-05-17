Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbZEQTlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbZEQTlx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 15:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbZEQTll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 15:41:41 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:49119 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbZEQTlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 15:41:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=v4sq7AtQ/34VUiuYKdy0jSo7EiXvayOxjpANCwVqX72J2fZdxkxOQG4EEM8G2RDtWP
         vB5eebpdPHvgT4XnCYj2OfADmSP55Kh1WnPi0f34g3zWHtQMfYE430k0nolsw+OVjP6A
         Y0yxZqeiLBikUbYXQruScx8T30McUM79hLyzY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: PATA DMA problem leading to kernel panic on reading movie DVDs
Date: Sun, 17 May 2009 21:45:45 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-00442-ga3668b0; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org,
       Martin Lottermoser <Martin.Lottermoser@t-online.de>,
       linux-ide@vger.kernel.org
References: <20090517091224.GA8280@wanza.invalid> <20090517121444.GA8733@wanza.invalid> <20090517193409.GC2976@liondog.tnic>
In-Reply-To: <20090517193409.GC2976@liondog.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905172145.45756.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 May 2009 21:34:09 Borislav Petkov wrote:
> (adding Bart to CC)
> 
> Hi Bart,
> 
> please take a look at the OOPS below, seems like we BUG() in ide_intr() at
> BUG_ON(!hwif->handler) which shouldn't happen. Full message is at:
> 
> http://www.gossamer-threads.com/lists/linux/kernel/1077445.
> 
> It is 2.6.29.3 with both PIIX_IDE and ata_piix compiled and it could be
> that those two step on each other's toes, but this is only wild stab in
> the dark.
> 
> I'm sure you have more ideas.

Yes, see my other mail.

[ After writing "I will cc: linux-ide on IDE/ATA problems" 100x times
  on the whiteboard... ;-) ]

> On Sun, May 17, 2009 at 02:14:44PM +0200, Martin Lottermoser wrote:
> > Hello,
> > 
> > On Sun, May 17, 2009 at 01:15:35PM +0200, Martin Lottermoser wrote:
> > > no, I don't have the necessary cable for that, but I'll provide a
> > > photograph of the screen and put it on my web site.
> > 
> > I've done that now. The file is available from this URL:
> > 
> >   http://home.vrweb.de/martin.lottermoser/linux/
> > 
> > The directory contains a file "0-readme.txt" which explains what the
> > files in the directory are; I've added the kernel configuration and the
> > syslog.
> > 
> > Regards,
> > Martin Lottermoser
> > -- 
> > Martin Lottermoser             Martin.Lottermoser at _REMOVE_t-online.de
> > Greifswaldstrasse 28
> > 38124 Braunschweig             http://home.vrweb.de/martin.lottermoser
> > Germany
