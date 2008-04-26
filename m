Return-Path: <linux-kernel-owner+w=401wt.eu-S1761002AbYDZXeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761002AbYDZXeN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 19:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbYDZXd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 19:33:56 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:53151 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbYDZXdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 19:33:55 -0400
Message-ID: <4813BBE9.2010803@keyaccess.nl>
Date: Sun, 27 Apr 2008 01:34:01 +0200
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
Subject: Re: [patch 00/54] PNP cleanup, v4
References: <20080425183807.366134771@ldl.fc.hp.com>
In-Reply-To: <20080425183807.366134771@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25-04-08 20:38, Bjorn Helgaas wrote:

> I'm still working through some issues with removing the
> fixed pnp_resource_table.  But I'd like to get some of
> the earlier patches off my plate, so here they are. 

Good idea...

[patch 01/54] PNP: turn on -DDEBUG when CONFIG_PNP_DEBUG is set
[patch 06/54] PNP: add pnp_eisa_id_to_string()
[patch 07/54] PNP: add pnp_alloc_dev()
[patch 17/54] PNP: add debug output to option registration
[patch 20/54] PNP: add debug output to encoders
[patch 28/54] PNP: remove pnp_mem_flags() as an lvalue
[patch 31/54] PNP: reduce redundancy in pnp_assign_port() and others
[patch 32/54] PNP: reduce redundancy in pnp_check_port() and others
[patch 33/54] PNP: reduce redundancy in pnp_set_current_resources()
[patch 34/54] PNP: check for conflicts with all resources, not just earlier 
[patch 35/54] PNP: pass resources, not indexes, to pnp_check_port(), et al
[patch 36/54] PNP: convert resource checks to use pnp_get_resource(), not
[patch 37/54] PNP: convert encoders to use pnp_get_resource(), not
[patch 40/54] PNP: make pnp_resource_table private to PNP core
[patch 42/54] PNP: add struct pnp_resource
[patch 43/54] PNP: add pnp_resource index for ISAPNP
[patch 45/54] PNP: make generic pnp_add_irq_resource()
[patch 46/54] PNP: make generic pnp_add_dma_resource()
[patch 47/54] PNP: make generic pnp_add_io_resource()
[patch 48/54] PNP: make generic pnp_add_mem_resource()
[patch 49/54] PNP: use pnp_get_pnp_resource() in resource assignment
[patch 51/54] PNPACPI: move _CRS/_PRS warnings closer to the action
[patch 52/54] PNP: make interfaces private to the PNP core
[patch 53/54] ISAPNP: remove unused pnp_dev->regs field
[patch 54/54] PNPBIOS: remove include/linux/pnpbios.

All of the above Acked-By: Rene Herman <rene.herman@gmail.com>

[patch 21/54] PNP: add debug when assigning PNP resources
[patch 26/54] PNP: factor pnp_init_resource_table() and
[patch 29/54] PNP: convert resource accessors to use pnp_get_resource(), not
[patch 38/54] PNP: remove PNP_MAX_* uses
[patch 41/54] PNP: remove pnp_resource_table references from resource
[patch 44/54] PNP: add pnp_new_resource() to find a new unset pnp_resource
[patch 50/54] ISAPNP: fold isapnp_read_resources() back into

The above just now commented on...

[patch 02/54] ISAPNP: move config register addresses out of isapnp.h
[patch 04/54] PNP: make pnp_add_id() internal to PNP core
[patch 05/54] PNP: change pnp_add_id() to allocate its own pnp_id structures
[patch 08/54] PNP: make pnp_add_card_id() internal to PNP core
[patch 09/54] PNP: change pnp_add_card_id() to allocate its own pnp_id
[patch 10/54] ISAPNP: pull pnp_add_card_id() out of isapnp_parse_card_id()
[patch 11/54] PNP: add pnp_alloc_card()
[patch 13/54] PNPACPI: use temporaries to reduce repetition
[patch 14/54] PNPACPI: hoist dma_flags() out of
[patch 15/54] PNPACPI: extend irq_flags() to set IORESOURCE_IRQ_SHAREABLE
[patch 16/54] PNPACPI: pass pnp_dev instead of acpi_handle
[patch 18/54] PNP: remove pnp_resource_table from internal get/set
[patch 19/54] PNP: remove more pnp_resource_table arguments
[patch 22/54] PNP: add pnp_init_resources(struct pnp_dev *) interface
[patch 23/54] PNP: remove pnp_resource_table from internal
[patch 24/54] PNP: remove unused interfaces using pnp_resource_table
[patch 25/54] PNP: use dev_printk when possible
[patch 27/54] PNP: add pnp_get_resource() interface
[patch 30/54] PNP: use conventional "i" for loop indices
[patch 39/54] rtc: dont reference pnp_resource_table directly

The above already had my Acked-By.

[patch 03/54] PNPACPI: continue after _CRS and _PRS errors
[patch 12/54] PNPACPI: pnpacpi_encode_ext_irq() wrongly set "irq" instead of

The above no opinion.

The series has also been (lightly) tested with ISA-PnP on two machines.

Rene.
