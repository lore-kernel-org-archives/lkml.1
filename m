Return-Path: <linux-kernel-owner+w=401wt.eu-S1755646AbYGSUOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646AbYGSUOd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 16:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbYGSUOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 16:14:25 -0400
Received: from 24.mail-out.ovh.net ([213.186.42.50]:59486 "HELO
	24.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752198AbYGSUOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 16:14:24 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Jul 2008 16:14:24 EDT
Date: Sat, 19 Jul 2008 22:04:19 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, Pierre Ossman <drzeus@drzeus.cx>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Victor <linux@maxim.org.za>, Ville Syrjala <syrjala@sci.fi>,
       Marc Pignat <marc.pignat@hevs.ch>
Subject: Re: [PATCH 3/3] at91_mci: introduce per-mci-revision conditional
	code
Message-ID: <20080719200419.GA368@game.jcrosoft.org>
Mail-Followup-To: Ben Dooks <ben-linux@fluff.org>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	Pierre Ossman <drzeus@drzeus.cx>,
	ARM Linux Mailing List <linux-arm-kernel@lists.arm.linux.org.uk>,
	Linux Kernel list <linux-kernel@vger.kernel.org>,
	Andrew Victor <linux@maxim.org.za>, Ville Syrjala <syrjala@sci.fi>,
	Marc Pignat <marc.pignat@hevs.ch>
References: <487F13E9.2060601@atmel.com> <20080717110403.GH24620@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080717110403.GH24620@fluff.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Ovh-Tracer-Id: 5293136938418351004
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12:04 Thu 17 Jul     , Ben Dooks wrote:
> On Thu, Jul 17, 2008 at 11:42:01AM +0200, Nicolas Ferre wrote:
> > We used to manage features and differences on a per-cpu basis. As several
> > cpus share the same mci revision, this patch aggregates cpus that have the
> > same IP revision in one defined constant.
> >
> > Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> > ---
> > drivers/mmc/host/at91_mci.c |   21 +++++++++++++--------
> > 1 files changed, 13 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
> > index 4e3edf3..a95529c 100644
> > --- a/drivers/mmc/host/at91_mci.c
> > +++ b/drivers/mmc/host/at91_mci.c
> > @@ -80,6 +80,11 @@
> >
> > #define DRIVER_NAME "at91_mci"
> >
> > +#define AT91MCI_REV2	(  cpu_is_at91sam9260() \
> > +			|| cpu_is_at91sam9263() \
> > +			|| cpu_is_at91cap9() \
> > +			|| cpu_is_at91sam9rl())
> > +
> 
> How about making it an inline function to avoid the horrible
> upper-case all throughtout?
> 
How about also naming as at91mci_is_rev2() to a few more explicit?

Best Regards,
J.
