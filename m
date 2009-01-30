Return-Path: <linux-kernel-owner+w=401wt.eu-S1753638AbZA3RDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbZA3RDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 12:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbZA3RDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 12:03:01 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:56152 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbZA3RDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 12:03:00 -0500
Date: Sat, 31 Jan 2009 02:03:00 +0900 (JST)
Message-Id: <20090131.020300.82352947.anemo@mba.ocn.ne.jp>
To: dan.j.williams@intel.com
Cc: g.liakhovetski@gmx.de, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, maciej.sosnowski@intel.com,
       hskinnemoen@atmel.com, nicolas.ferre@atmel.com
Subject: Re: [PATCH 07/13] dmaengine: introduce dma_request_channel and
 private channels
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <e9c3a7c20812020916ud0b426cvd0764f23a97973ad@mail.gmail.com>
References: <20081114213453.32354.53002.stgit@dwillia2-linux.ch.intel.com>
	<Pine.LNX.4.64.0812021642120.5663@axis700.grange>
	<e9c3a7c20812020916ud0b426cvd0764f23a97973ad@mail.gmail.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Dec 2008 10:16:05 -0700, "Dan Williams" <dan.j.williams@intel.com> wrote:
> > I think, there is a problem with your dma_request_channel() /
> > private_candidate() implementation: your current version only tries one
> > channel from a dma device list, which matched capabilities. If this
> > channel is not accepted by the client, you do not try other channels from
> > this device and just go to the next one...
> 
> Which dma driver are you using?  The dmaengine code assumes that all
> channels on a device are equal.  It sounds like there are differences
> between peer-channels on the device in this case.  If the driver
> registers a device per channel that should give the flexibility you
> want.

I'm writing a new dma driver.  My DMAC has multiple channels and only
one channel is capable for generic memcpy and other channels have
fixed role.

Does new framework allow dma driver make only one channel public?
Or should I register two dma_device for DMA_MEMCPY and DMA_SLAVE?
Could you give me some advice?

---
Atsushi Nemoto
