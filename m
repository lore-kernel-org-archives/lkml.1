Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbYDSEnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbYDSEnP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 00:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750836AbYDSEm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 00:42:58 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:38838 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbYDSEm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 00:42:57 -0400
Message-ID: <48097909.7010203@keyaccess.nl>
Date: Sat, 19 Apr 2008 06:46:01 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 22/53] PNP: factor pnp_init_resource_table() and pnp_clean_resource_table()
References: <20080418204955.342963315@ldl.fc.hp.com> <20080418205051.704761191@ldl.fc.hp.com> <480920BB.9010506@keyaccess.nl> <200804182157.34313.bjorn.helgaas@hp.com> <48097886.9000907@keyaccess.nl>
In-Reply-To: <48097886.9000907@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19-04-08 06:43, Rene Herman wrote:

> pnp: the driver 'cs4236_isapnp' has been registered
> cs4236_isapnp 01:01.00: driver attached
> cs4236_isapnp 01:01.02: driver attached
> cs4236_isapnp 01:01.03: driver attached
> cs4236_isapnp 01:01.00: too many I/O port resources
> cs4236_isapnp 01:01.00: too many I/O port resources
> cs4236_isapnp 01:01.00: too many I/O port resources
> cs4236_isapnp 01:01.00: too many IRQ resources
> cs4236_isapnp 01:01.00: too many DMA resources
> cs4236_isapnp 01:01.00: too many DMA resources
> cs4236_isapnp 01:01.00: activated

Oh, yes, 01:01.00 has three port resources, 1 IRQ resource and 2 DMA resources.

Rene.
