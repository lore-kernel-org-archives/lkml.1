Return-Path: <linux-kernel-owner+w=401wt.eu-S966542AbYD1SdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966542AbYD1SdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 14:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966155AbYD1Sak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 14:30:40 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:56197 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966177AbYD1Sah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 14:30:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=kbUbMTYwnU0t0gJZHtnBmPxdvIwnZFFrTmy6eLFgN7VDRhEJq2yMDBwbQNX5fvPl2PEMuorzUa6OwB83mCtjd2zhIbjzIRTc97sT5d1Y1eX1U04V1sZBDobvqIm7gZTlaH1C6+7uAe13bnm9ND/P/dvws10eU1jz4zmQHluDTFk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [2.6 patch] ARM: always select HAVE_IDE
Date: Sun, 27 Apr 2008 23:06:00 +0200
User-Agent: KMail/1.9.9
Cc: Adrian Bunk <bunk@kernel.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
References: <20080414141659.GF6695@cs181133002.pp.htv.fi> <200804272032.44273.bzolnier@gmail.com> <20080427202929.GB32762@uranus.ravnborg.org>
In-Reply-To: <20080427202929.GB32762@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804272306.01052.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 April 2008, Sam Ravnborg wrote:
> > > 
> > > I do actually not care much how this gets resolved (we could even 
> > > ditch HAVE_IDE and provide asm/ide.h on all architectures) if there's 
> > > general agreement that this is the way to go.
> > 
> > Seems like a way to go now that all crazy IDE core code vs arch code
> > inter-dependiences have been fixed (the ideal solution would be to ditch
> > asm/ide.h completely but this requires some more time/work).
> 
> I invented HAVE_IDE in the past to make it trivial for arm to
> use drivers/Kconfig.
> And that incentive are not broken by your suggestion so fine with me.

Cool.

> But I really do not know about s390. They were the only one
> without IDE in the past.

They don't seem to support neither PCI nor ISA so I think that we
should just special case them (== make IDE depend on BLOCK && !S390).

Thanks,
Bart
