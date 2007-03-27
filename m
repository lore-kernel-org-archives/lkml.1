Return-Path: <linux-kernel-owner+w=401wt.eu-S934168AbXC1JrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934168AbXC1JrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 05:47:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933779AbXC1JrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 05:47:10 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3855 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933780AbXC1JrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 05:47:08 -0400
Date: Tue, 27 Mar 2007 21:32:01 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan <alan@lxorguk.ukuu.org.uk>, Len Brown <lenb@kernel.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: ATA ACPI (was Re: Linux 2.6.21-rc5)
Message-ID: <20070327213200.GA5842@ucw.cz>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <4608B0CA.1040005@garzik.org> <4608B1A2.3040305@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4608B1A2.3040305@gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>So if you have reported a regression in the 2.6.21-rc 
> >>series, please check 2.6.21-rc5, and update your 
> >>report as appropriate (whether fixed or "still 
> >>problems with xyzzy").
> >
> >[just got back from vacation, or would have sent this 
> >earlier]
> >
> >FWIW, I'm still leaning towards disabling libata ACPI 
> >support by default for 2.6.21.
> >
> >Upstream has Alan's fix for the worst PATA problems, 
> >but for different reasons, I think PATA ACPI and SATA 
> >ACPI support in libata does not feel quite ready for 
> >prime time in 2.6.21.
> >
> >Scream now, or hold your peace until 2.6.22... :)
> 
> I second disabling ACPI for 2.6.21.

Ugh.. does that mean we'll have 'regression reports' as in 'it worked
ok in -rc5, broken in final?

Well, suspend is currently so broken that we'll be flooded by reports,
anyway, but.... could we get at least define in code so that we can
tell users to flip it?

Or maybe it is enough to make libata dependend on EXPERIMETAL?
...making it dependend on BROKEN should be definitely enough...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
