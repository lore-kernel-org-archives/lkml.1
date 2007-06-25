Return-Path: <linux-kernel-owner+w=401wt.eu-S1751882AbXFYU2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbXFYU2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 16:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbXFYU2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 16:28:32 -0400
Received: from mailhub.fokus.fraunhofer.de ([193.174.154.14]:34109 "EHLO
	mailhub.fokus.fraunhofer.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752750AbXFYU2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 16:28:30 -0400
Date: Mon, 25 Jun 2007 22:26:20 +0200
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: harald@skogtun.org, dwmw2@infradead.org
Cc: schilling@fokus.fraunhofer.de, linux-kernel@vger.kernel.org, david@lang.hm
Subject: Re: Linux Kernel include files
Message-ID: <468024ec.9RebHj/O0BpNRyoY%Joerg.Schilling@fokus.fraunhofer.de>
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de>
 <Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm>
 <467b0bf2.Xfs7T8Ys4nY9ZNLW%Joerg.Schilling@fokus.fraunhofer.de>
 <1182483527.10524.31.camel@shinybook.infradead.org>
 <467fdc75.0ficjl92unPDO1uk%Joerg.Schilling@fokus.fraunhofer.de>
 <1182785277.12109.121.camel@pmac.infradead.org>
 <87wsxrdi6e.fsf@basilikum.skogtun.org>
In-Reply-To: <87wsxrdi6e.fsf@basilikum.skogtun.org>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Harald Arnesen <harald@skogtun.org> wrote:

> David Woodhouse <dwmw2@infradead.org> writes:
>
> >> >  Can you be more specific about why this is a problem? Don't
> >> > we mostly define those crappy types using arch-specific knowledge, as
> >> > 'int', 'long', etc?
> >> 
> >> I recommend you to install Sun Studio and to try to compile star or cdrtools
> >> using Sun Studio by calling "make CCOM_suncc".
> >>
> >> ftp://ftp.berlios.de/pub/star/alpha/
> >> ftp://ftp.berlios.de/pub/cdrecord/alpha/
> >> 
> >> You may need to hand edit the file incs/<arch-dir>/{xconfig.h!rules.conf}
> >> 
> >> in order to enable the auto-disabled features.
> >> 
> >> In any case, self reading the error messages from Sun Studio helps more than
> >> trying to discuss it.
> >
> > I have no interest in doing this for myself, and I suspect that if I
> > tried it I'd find that Sun Studio doesn't exist for Linux/PowerPC
> > anyway. Please just show the error messages.
>
> Apart from the usual whining about GNU make, the error message is:
> make: *** No rule to make target `CCOM_suncc'.  Stop.
>
> If I actually install smake, as Jörg recommends, the message becomes:
> smake: Can't find any source for 'CCOM_suncc'.
> smake: Couldn't make 'CCOM_suncc'.

Well, I was in hope that a small typo (in special as the correct spelling is in 
the file README.compile) should not be a problem.

You need to use CCOM=suncc 

Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       schilling@fokus.fraunhofer.de     (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/old/private/ ftp://ftp.berlios.de/pub/schily
