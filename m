Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770AbZEQTvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbZEQTvP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 15:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbZEQTuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 15:50:55 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:62835 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbZEQTuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 15:50:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=gvm3xt+iPD/dQJ5u7sUorQ707R3AzvacyV7+/EXza+LbqNl6l+3tj2I3TqlawpnUrv
         RMtPvgd5tBYW9kWL9PfJtntagq+m0BW/QLjk6LeuHvc4vrXv1q3sk306Yov6dZhWgnlI
         XNB7nGkWCcbLMXhicdoKLbuuCv/IlmI/TyuUY=
Date: Sun, 17 May 2009 21:50:51 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Borislav Petkov <petkovbb@googlemail.com>, linux-kernel@vger.kernel.org,
       Martin Lottermoser <Martin.Lottermoser@t-online.de>,
       linux-ide@vger.kernel.org
Subject: Re: PATA DMA problem leading to kernel panic on reading movie DVDs
Message-ID: <20090517195051.GA5142@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@gmail.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Borislav Petkov <petkovbb@googlemail.com>,
	linux-kernel@vger.kernel.org,
	Martin Lottermoser <Martin.Lottermoser@t-online.de>,
	linux-ide@vger.kernel.org
References: <20090517091224.GA8280@wanza.invalid> <20090517121444.GA8733@wanza.invalid> <20090517193409.GC2976@liondog.tnic> <200905172145.45756.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200905172145.45756.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 17, 2009 at 09:45:45PM +0200, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 17 May 2009 21:34:09 Borislav Petkov wrote:
> > (adding Bart to CC)
> > 
> > Hi Bart,
> > 
> > please take a look at the OOPS below, seems like we BUG() in ide_intr() at
> > BUG_ON(!hwif->handler) which shouldn't happen. Full message is at:
> > 
> > http://www.gossamer-threads.com/lists/linux/kernel/1077445.
> > 
> > It is 2.6.29.3 with both PIIX_IDE and ata_piix compiled and it could be
> > that those two step on each other's toes, but this is only wild stab in
> > the dark.
> > 
> > I'm sure you have more ideas.
> 
> Yes, see my other mail.

Saw it right after hitting send.

> [ After writing "I will cc: linux-ide on IDE/ATA problems" 100x times
>   on the whiteboard... ;-) ]

And I CC'ed you instead, this has even bigger effect :)

-- 
Regards/Gruss,
    Boris.
