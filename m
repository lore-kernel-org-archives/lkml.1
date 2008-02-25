Return-Path: <linux-kernel-owner+w=401wt.eu-S1758869AbYBYVbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869AbYBYVbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 16:31:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbYBYVbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 16:31:35 -0500
Received: from mail.atlantis.sk ([80.94.52.35]:33443 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310AbYBYVbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 16:31:34 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Compex FreedomLine 32 PnP-PCI2 broken with de2104x
Date: Mon, 25 Feb 2008 22:31:25 +0100
User-Agent: KMail/1.9.9
Cc: Grant Grundler <grundler@parisc-linux.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
References: <200801262158.12016.linux@rainbow-software.org> <20080218032111.GA7970@colo.lackof.org> <47C26E0E.2070109@pobox.com>
In-Reply-To: <47C26E0E.2070109@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802252231.27081.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 February 2008 08:28:14 Jeff Garzik wrote:
> Grant Grundler wrote:
> > ISTR there was a time when tulip would compete with de4x5 for devices.
> > tulip is the preferred driver. That's clearly no longer the case
> > and perhaps both distro's need to revisit this.
>
> The only reason why de4x5 still exists is that the /tulip/ driver fails
> to work on a few chips like the 21142 (43?) shipped in various alpha boxen.
>
> de4x5 needs to go away, it's been unmaintained for ages, doesn't support
> any of the new hotplug APIs.

But has extensive port auto-detection which seems to work great (at least on 
my card). I don't feel like porting that code to de2104x - the code looks 
complex.

>
> > de2104x is a "work in progress".
> > That's why it's marked "EXPERIMENTAL" in the Kconfig file.
>
> It's not a work in progress, it works just fine for most people (the few
> that are left).
>
> Last I heard, there was a problem with non-twisted-pair stuff, but
> that's about it.
>
> 'experimental' is generally a poorly maintained marker.

So we have two unmaintained drivers - one that works fine (and is production 
quality - or at least seems to be) but does not support hotplug APIs and one 
that was never finished (the TP-unplug problem is present at least since 
2003).
Perhaps de4x5 could be ported to new API(s)? I think that it's much easier 
than fixing obscure hardware-related problems like cable auto-detection.

-- 
Ondrej Zary
