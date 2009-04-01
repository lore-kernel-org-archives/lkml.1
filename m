Return-Path: <linux-kernel-owner+w=401wt.eu-S1764933AbZDAQVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764933AbZDAQVB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 12:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761591AbZDAQUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 12:20:49 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:52701 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761229AbZDAQUs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 12:20:48 -0400
Date: Thu, 02 Apr 2009 01:20:45 +0900 (JST)
Message-Id: <20090402.012045.61946991.anemo@mba.ocn.ne.jp>
To: dan.j.williams@intel.com
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org, haavard.skinnemoen@atmel.com
Subject: Re: [PATCH 1/2] dmaengine: TXx9 Soc DMA Controller driver
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <e9c3a7c20903311234t63335987l46480cd27a326022@mail.gmail.com>
References: <20090321.212920.25912728.anemo@mba.ocn.ne.jp>
	<20090326.231243.112855442.anemo@mba.ocn.ne.jp>
	<e9c3a7c20903311234t63335987l46480cd27a326022@mail.gmail.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009 12:34:59 -0700, Dan Williams <dan.j.williams@intel.com> wrote:
> > Unfortunately, not so simple.  If I created a dma_device for each
> > channel, all chan->chan_id will be 0 and all chan->device->dev points
> > same platform device.  This makes client driver hard to select the
> > particular channel.  Making a platform device for each channel will
> > solve this, but it looks wrong way to go for me.
> 
> Why?  mv_xor, iop-adma, and ioat each have a platform or pci device
> per channel so you would be in good company.

Hmm, indeed.  I will try it.  Thanks.
---
Atsushi Nemoto
