Return-Path: <linux-kernel-owner+w=401wt.eu-S1757376AbYESXWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbYESXWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 19:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761483AbYESXVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 19:21:30 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:55911 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759622AbYESXVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 19:21:10 -0400
Message-ID: <48320BD0.8010900@keyaccess.nl>
Date: Tue, 20 May 2008 01:22:56 +0200
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
Subject: Re: [patch 4/4] PNP: dont sort by type in /sys/.../resources
References: <20080515220726.029505668@ldl.fc.hp.com> <20080515220755.127620227@ldl.fc.hp.com>
In-Reply-To: <20080515220755.127620227@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16-05-08 00:07, Bjorn Helgaas wrote:

> Rather than stepping through all IO resources, then stepping through
> all MMIO resources, etc., we can just iterate over the resource list
> once directly.
> 
> This can change the order in /sys, e.g.,
> 
>     # cat /sys/devices/pnp0/00:07/resources     # OLD
>     state = active
>     io 0x3f8-0x3ff
>     irq 4
> 
>     # cat /sys/devices/pnp0/00:07/resources     # NEW
>     state = active
>     irq 4
>     io 0x3f8-0x3ff
> 
> The old code artificially sorted resources by type; the new code
> just lists them in the order we read them from the ISAPNP hardware
> or the BIOS.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Acked-by: Rene Herman <rene.herman@gmail.com>

Rene.

