Return-Path: <linux-kernel-owner+w=401wt.eu-S1758245AbZJHX0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245AbZJHX0x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 19:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753717AbZJHX0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 19:26:51 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:56769 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbZJHX0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 19:26:50 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+OVpsLyTk7pONxQ6weFjTs
Date: Thu, 8 Oct 2009 16:26:03 -0700
From: Tony Lindgren <tony@atomide.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-omap@vger.kernel.org, Denis Karpov <ext-denis.2.karpov@nokia.com>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [GIT PULL] omap fixes for v2.6.32-rc3
Message-ID: <20091008232603.GB25892@atomide.com>
References: <20091007185112.GJ7899@atomide.com> <94a0d4530910081429m7ad88b43q38245109f3252078@mail.gmail.com> <20091008214140.GJ7417@atomide.com> <94a0d4530910081513w1a919dc2s50eca41966a2261d@mail.gmail.com> <94a0d4530910081520t66ce7567xe142979a35b1245@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <94a0d4530910081520t66ce7567xe142979a35b1245@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Contreras <felipe.contreras@gmail.com> [091008 15:20]:
> On Fri, Oct 9, 2009 at 1:13 AM, Felipe Contreras
> <felipe.contreras@gmail.com> wrote:
> > On Fri, Oct 9, 2009 at 12:41 AM, Tony Lindgren <tony@atomide.com> wrote:
> >> * Felipe Contreras <felipe.contreras@gmail.com> [091008 14:29]:
> >>> On Wed, Oct 7, 2009 at 9:51 PM, Tony Lindgren <tony@atomide.com> wrote:
> >>>

<snip snip>

> >>> The beagleboard is still not booting for me with this branch, I need
> >>> to add these two patches:
> >>>
> >>> * http://patchwork.kernel.org/patch/50721/
> >>>
> >>
> >> This should go to the mainline kernel via Samuel as it's
> >> drivers/mfd related.
> >>
> >>> This one is needed because the defconfig has:
> >>> CONFIG_TWL4030_USB=y
> >>>
> >>> * http://patchwork.kernel.org/patch/50970/
> >>>
> >>> This is needed because most people boot from an MMC.
> >>
> >> And this should go in via the mmc list.
> >
> > Should it?
> >
> > Here you can see Uwe Kleine-König sending the original patch without
> > even CC'ing the mmc list:
> > http://marc.info/?l=linux-kernel&m=124820861213849&w=2
> >
> > And it was unintentionally broken by this one:
> > http://marc.info/?l=linux-mmc&m=125249763422227&w=2
> 
> Er, actually that one was ok, the problem was introduced only in the
> final version:
> http://marc.info/?l=linux-mmc&m=125366315417006&w=2

Right, looks like Roger forgot to Cc linux-mmc.
 
> > I don't see what we are waiting for, the code is clearly broken, even
> > the compiler warns that nobody is using omap_hsmmc_probe().

I've sent Roger's patch to Andrew & linux-mmc so hopefully it will get
merged soon:

http://www.mail-archive.com/linux-mmc@vger.kernel.org/msg00539.html

Regards,

Tony
