Return-Path: <linux-kernel-owner+w=401wt.eu-S1759137AbYFDKFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759137AbYFDKFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 06:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbYFDKFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 06:05:32 -0400
Received: from cantor.suse.de ([195.135.220.2]:51342 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243AbYFDKFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 06:05:31 -0400
Date: Wed, 4 Jun 2008 12:06:03 +0200
From: Olaf Dabrunz <od@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Olaf Dabrunz <od@suse.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Jon Masters <jonathan@jonmasters.org>,
       linux-kernel@vger.kernel.org, Stefan Assmann <sassmann@suse.de>
Subject: Re: [PATCH 7/7] bootirqquirk= parameter to enable bootirq quirks
	for additional chips
Message-ID: <20080604100602.GJ27585@suse.de>
Mail-Followup-To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
	Jon Masters <jonathan@jonmasters.org>, linux-kernel@vger.kernel.org,
	Stefan Assmann <sassmann@suse.de>
References: <12124107071847-git-send-email-od@suse.de> <1212410707427-git-send-email-od@suse.de> <alpine.LFD.1.10.0806031255230.3235@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.1.10.0806031255230.3235@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03-Jun-08, Thomas Gleixner wrote:
> On Mon, 2 Jun 2008, Olaf Dabrunz wrote:
> > From: Olaf Dabrunz <od@suse.de>
> > 
> > The existing bootirq quirks and the reroute workaround may work for other chips
> > where we could not test them. This parameter allows users to apply these to
> > other chips without the need to re-build the kernel.
> > 
> > This patch was conceived simultaneously by Stefan Assmann, Daniel Gollub and
> > Olaf Dabrunz. The implementation is the author's.
> > 
> >     bootirqquirk=0x<vendor>,0x<device>,<quirk_type>
> > 
> >     - quirk type  1 - 32 selects an IRQ reroute algorithm for devices
> >       connected to that PCI bridge (currently only algorithm "1" is
> >       implemented),
> > 
> >     - quirk type 33 -  x applies one of the known quirks to the PCI
> >       device, currently these:
> > 
> >         33 -> quirk_disable_intel_boot_interrupt
> >         34 -> quirk_disable_broadcom_boot_interrupt
> >         35 -> quirk_disable_amd_8111_boot_interrupt
> >         36 -> quirk_disable_amd_813x_boot_interrupt
> >         37 -> quirk_disable_amd_sb700s_boot_interrupt
> 
> Oh no. This can be used as an debug aid when the need arises, but we
> dont want to add this to the kernel.

Yes, I agree. We should rather patch in additional chips as needed.
This is more a helper functionality for early testing.

Regards,

-- 
Olaf Dabrunz (od/odabrunz), SUSE Linux Products GmbH, Nürnberg

