Return-Path: <linux-kernel-owner+w=401wt.eu-S934334AbYD1RVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934334AbYD1RVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 13:21:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762315AbYD1RUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 13:20:55 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:28728 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbYD1RUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 13:20:55 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [patch 29/54] PNP: convert resource accessors to use pnp_get_resource(), not pnp_resource_table
Date: Mon, 28 Apr 2008 11:19:53 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080425183807.366134771@ldl.fc.hp.com> <20080425183930.010114245@ldl.fc.hp.com> <4813A1BB.600@keyaccess.nl>
In-Reply-To: <4813A1BB.600@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804281119.54479.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 April 2008 03:42:19 pm Rene Herman wrote:
> On 25-04-08 20:38, Bjorn Helgaas wrote:
> 
> > +static inline resource_size_t pnp_port_flags(struct pnp_dev *dev,
> > +static inline resource_size_t pnp_mem_flags(struct pnp_dev *dev,
> > +static inline resource_size_t pnp_irq_flags(struct pnp_dev *dev,
> > +static inline resource_size_t pnp_dma_flags(struct pnp_dev *dev,
> 
> These should return unsigned long.

Fixed, thanks. 

Bjorn
