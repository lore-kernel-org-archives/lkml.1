Return-Path: <linux-kernel-owner+w=401wt.eu-S1752030AbZGUNpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbZGUNpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 09:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbZGUNpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 09:45:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59303 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbZGUNpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 09:45:42 -0400
Subject: Re: SDIO Stack and Device Support
From: Dan Williams <dcbw@redhat.com>
To: Robert Emanuele <rob@emanuele.us>
Cc: Jonathan Cameron <Jonathan.Cameron@gmail.com>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <9f53b4330907171620u5fd71e69t862f582a05251f0@mail.gmail.com>
References: <9f53b4330907161718ydbac090k2afc7a749fc9f6f2@mail.gmail.com>
	 <4A604246.5060204@gmail.com>
	 <9f53b4330907171620u5fd71e69t862f582a05251f0@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 09:46:11 -0400
Message-Id: <1248183971.6558.11.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-17 at 16:20 -0700, Robert Emanuele wrote:
> This support for these wireless chips in the mainline kernel is great.
>  Originally I was looking at wireless SDIO cards from Spectec and
> Silex.  What manufacturers use the libertas/Marvell chipsets in SDIO
> Cards?  (or are they only available as modules?)

Wi2Wi makes SDIO boards based off the 8686.  I don't offhand know of
consumer-type  dongles or SDIO cards that you can get that contain the
libertas chips, they are usually repackaged as more embedded-type
modules.  But if you look around for 8686 or 8385 you can find them.

Dan

> Thank you,
> 
> Rob
> 
> On Fri, Jul 17, 2009 at 2:20 AM, Jonathan
> Cameron<Jonathan.Cameron@gmail.com> wrote:
> > Robert Emanuele wrote:
> >> Greetings all,
> >>
> >> I'm trying to find out more information about the status of an SDIO
> >> stack and SDIO devices in the kernel.  I see under drivers/mmc/ some
> >> SDIO support.
> >>
> >> I'm evaluating the potential of getting a Wireless SDIO card to work
> >> with the 2.6 kernel.  So far all I see in the kernel is support for an
> >> SDIO UART.  There is a patch on sourceforge for an SDIO stack and
> >> drivers from Atheros but that is for 2.6.18.  Is there current support
> >> for other SDIO wireless devices in the kernel?
> >>
> > There is pretty good support for the Marvell chips (sd8686 etc) in the
> > mainline
> > kernel. Take a look under drivers/net/wireless/libertas/
> >
> > I've also copied in the linux-wireless list.
> >
> >
> >
> >
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

