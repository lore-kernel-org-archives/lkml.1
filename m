Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbYFAVAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbYFAVAW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 17:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbYFAVAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 17:00:06 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:48260 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbYFAVAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 17:00:04 -0400
Message-ID: <48430E95.9000903@keyaccess.nl>
Date: Sun, 01 Jun 2008 23:03:17 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [patch 03/15] PNP: define PNP-specific IORESOURCE_IO_* flags
 alongside IRQ, DMA, MEM
References: <20080530224853.976744229@ldl.fc.hp.com> <20080530224931.975366762@ldl.fc.hp.com>
In-Reply-To: <20080530224931.975366762@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31-05-08 00:48, Bjorn Helgaas wrote:

> PNP previously defined PNP_PORT_FLAG_16BITADDR and PNP_PORT_FLAG_FIXED
> in a private header file, but put those flags in struct resource.flags
> fields.  Better to make them IORESOURCE_IO_* flags like the existing
> IRQ, DMA, and MEM flags.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Acked-by: Rene Herman <rene.herman@gmail.com>

Wondered a bit since only PnPACPI seems to directly encode those flags 
to a res->flags (as opposed to a port->flags) but pnp_assign_port() 
copies them over verbatim indeed...

Rene.
