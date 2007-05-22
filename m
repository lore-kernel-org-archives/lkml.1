Return-Path: <linux-kernel-owner+w=401wt.eu-S966314AbXEVP7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966314AbXEVP7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 11:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765543AbXEVP73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 11:59:29 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:40772 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758582AbXEVP72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 11:59:28 -0400
Date: Tue, 22 May 2007 16:59:03 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jeff Garzik <jeff@garzik.org>,
       Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
Message-ID: <20070522155902.GA27987@srcf.ucam.org>
References: <200705171423.46748.jesse.barnes@intel.com> <465228E2.1030405@garzik.org> <9e4733910705211726q38be6843ndac49f8adc25aad0@mail.gmail.com> <200705211856.56228.jbarnes@virtuousgeek.org> <9e4733910705220727t605f2522tc4eb97257735c0fb@mail.gmail.com> <20070522155439.20bf509f@the-village.bc.nu> <9e4733910705220816j778e00ecle86e209ef0111b8e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e4733910705220816j778e00ecle86e209ef0111b8e@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 11:16:47AM -0400, Jon Smirl wrote:

> The only reason the VBIOS is run is to initially reset the card. Once
> we get the card reset it isn't used any more. For almost all cards
> this is the only way to reset them, we have insufficient information
> to write this ourselves.

For suspend/resume to ever work reliably, we need to be able to 
reinitialise cards without BIOS support. It would be more useful to 
spend time on that.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
