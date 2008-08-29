Return-Path: <linux-kernel-owner+w=401wt.eu-S1759612AbYH2W1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759612AbYH2W1X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 18:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754636AbYH2W1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 18:27:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54230 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755411AbYH2W1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 18:27:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
Date: Sat, 30 Aug 2008 00:31:15 +0200
User-Agent: KMail/1.9.9
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "David Witbrodt" <dawitbro@sbcglobal.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Kernel Testers" <kernel-testers@vger.kernel.org>
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org> <200808292157.24179.rjw@sisk.pl> <86802c440808291413t4f31993fmba59a65aefd906ca@mail.gmail.com>
In-Reply-To: <86802c440808291413t4f31993fmba59a65aefd906ca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808300031.16708.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 29 of August 2008, Yinghai Lu wrote:
> On Fri, Aug 29, 2008 at 12:57 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Friday, 29 of August 2008, Rafael J. Wysocki wrote:
> >> On Friday, 29 of August 2008, Linus Torvalds wrote:
> >> >
> >> > Another week (my weeks do seem to be eight days, don't they? Very odd),
> >> > another -rc.
> >> >
> >> > The dirstat pretty much says it all:
> >> >
> >> >   43.0% arch/arm/configs/
> >> >   43.9% arch/arm/
> >> >   25.5% arch/powerpc/configs/
> >> >   26.8% arch/powerpc/
> >> >   73.9% arch/
> >> >    4.4% drivers/usb/musb/
> >> >    5.4% drivers/usb/
> >> >    4.0% drivers/watchdog/
> >> >   16.0% drivers/
> >> >    3.5% fs/
> >> >
> >> > yeah, the bulk of it is all config updates, and with arm and powerpc
> >> > leading the pack.
> >>
> >> Doesn't boot on my quad core test box, apparently because of an AHCI failure.
> >>
> >> Bisecting ...
> >
> > Bisection turned up commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd as the culprit:
> >
> > commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
> > Author: Yinghai Lu <yhlu.kernel@gmail.com>
> > Date:   Mon Aug 25 00:56:08 2008 -0700
> >
> >    x86: fix HPET regression in 2.6.26 versus 2.6.25, check hpet against BAR, v3
> >
> > Reverting this commit helps.
> >
> 
> can i get whole bootlog with "debug"?

http://www.sisk.pl/kernel/debug/mainline/2.6.27-rc5/broken.log

Thanks,
Rafael
