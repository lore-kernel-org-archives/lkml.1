Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbYHUMgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbYHUMgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 08:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbYHUMgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 08:36:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37149 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbYHUMgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 08:36:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>, Frans Pop <elendil@planet.nl>
Subject: Re: char/tpm: tpm_infineon no longer loaded for HP 2510p laptop
Date: Thu, 21 Aug 2008 14:40:26 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Marcel Selhorst <tpm@selhorst.net>,
       Kay Sievers <kay.sievers@vrfy.org>, Thomas Renninger <trenn@suse.de>,
       Adam Belay <ambx1@neo.rr.com>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200808181540.25286.elendil@planet.nl> <200808200956.52883.bjorn.helgaas@hp.com>
In-Reply-To: <200808200956.52883.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808211440.27577.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 20 of August 2008, Bjorn Helgaas wrote:
> On Monday 18 August 2008 07:40:24 am Frans Pop wrote:
> > While comparing the loaded modules for 2.6.26 and 2.6.27-rc3 for my HP 
> > 2510p, I noticed that the tpm_infineon module and related modules no 
> > longer get loaded automatically.
> > 
> > The difference seems to be that 2.6.26 listed:
> > /lib/modules/2.6.26.2/modules.alias:alias pnp:dIFX0102* tpm_infineon
> > /lib/modules/2.6.26.2/modules.alias:alias pnp:dIFX0101* tpm_infineon
> > 
> > while 2.6.27 has:
> > /lib/modules/2.6.27-rc3/modules.alias:alias acpi*:IFX0101:* tpm_infineon
> > /lib/modules/2.6.27-rc3/modules.alias:alias pnp:dIFX0101* tpm_infineon
> > 
> > My system has:
> > $ grep IFX /sys/bus/pnp/devices/*/id
> > /sys/bus/pnp/devices/00:02/id:IFX0102
> 
> drivers/char/tpm/tpm_infineon.c hasn't changed since v2.6.26.  I think
> the problem is more likely related to commit 22454cb99fc39f2629a:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=22454cb99fc39f2629ad06a7eccb3df312f8830e

Frans, could you verify if reverting commit 22454cb99fc39f2629a fixes the
problem for you?

Thanks,
Rafael
