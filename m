Return-Path: <linux-kernel-owner+w=401wt.eu-S1756935AbXITUCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935AbXITUCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 16:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbXITTyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 15:54:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39887 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610AbXITTyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 15:54:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alexey Starikovskiy <aystarik@gmail.com>
Subject: Re: 2.6.23-rc6: S4 and S5 no longer listed as supported on Toshiba Satellite A40
Date: Thu, 20 Sep 2007 22:07:12 +0200
User-Agent: KMail/1.9.5
Cc: Frans Pop <elendil@planet.nl>, Pavel Machek <pavel@ucw.cz>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Maciek Rutecki <maciej.rutecki@gmail.com>
References: <200709192014.08443.elendil@planet.nl> <200709202017.50934.elendil@planet.nl> <46F2BD0D.2010206@gmail.com>
In-Reply-To: <46F2BD0D.2010206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709202207.13101.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 20 September 2007 20:33, Alexey Starikovskiy wrote:
> Frans Pop wrote:
> > On Thursday 20 September 2007, you wrote:
> >> Please try this patch.
> > 
> > Works. All states are now listed again.
> > I've not tested suspend to disk, but suspend to ram and power off work fine.
> > 
> >> +printk(KERN_INFO PREFIX "(supports");
> >>  #ifdef CONFIG_SUSPEND
> >> -       printk(KERN_INFO PREFIX "(supports");
> >>         for (i = ACPI_STATE_S0; i < ACPI_STATE_S4; i++) {
> > 
> > Isn't there a risk now that we now end up printing
> >    ACPI: (supports)
> > if CONFIG_SUSPEND is not enabled and >S4 is not supported?
> > 
> > Or, more probably, it would print
> >    ACPI: (supports S5)
> Don't know what does it mean to support S0 exactly... :)
> > as it is unlikely that "off" is not supported :-)
> > 
> > Maybe S0 should be taken outside the #ifdef and the loop as that state is 
> > also basically always there?
> Don't think it is worth the trouble. We already have this loop almost completely unrolled,
> let's not make it complete mess...

Well, you could use "(supports S0" instead of just "(supports". ;-)

Greetings,
Rafael
