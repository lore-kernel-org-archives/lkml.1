Return-Path: <linux-kernel-owner+w=401wt.eu-S1757911AbYDZVmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911AbYDZVmZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 17:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753778AbYDZVmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 17:42:16 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:56948 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbYDZVmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 17:42:15 -0400
Message-ID: <4813A1BB.600@keyaccess.nl>
Date: Sat, 26 Apr 2008 23:42:19 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 29/54] PNP: convert resource accessors to use pnp_get_resource(),
 not pnp_resource_table
References: <20080425183807.366134771@ldl.fc.hp.com> <20080425183930.010114245@ldl.fc.hp.com>
In-Reply-To: <20080425183930.010114245@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25-04-08 20:38, Bjorn Helgaas wrote:

> +static inline resource_size_t pnp_port_flags(struct pnp_dev *dev,
> +static inline resource_size_t pnp_mem_flags(struct pnp_dev *dev,
> +static inline resource_size_t pnp_irq_flags(struct pnp_dev *dev,
> +static inline resource_size_t pnp_dma_flags(struct pnp_dev *dev,

These should return unsigned long.

Rene.
