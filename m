Return-Path: <linux-kernel-owner+w=401wt.eu-S932592AbXHFPMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592AbXHFPMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 11:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764148AbXHFPML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 11:12:11 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:40663 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942AbXHFPMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 11:12:10 -0400
Date: Mon, 6 Aug 2007 17:12:07 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: David Vrabel <david.vrabel@csr.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sdio: enhance IO_RW_EXTENDED support
Message-ID: <20070806171207.59fafa18@poseidon.drzeus.cx>
In-Reply-To: <46B6F877.7060504@csr.com>
References: <11858961933491-git-send-email-david.vrabel@csr.com>
	<20070804152304.65ed8f1b@poseidon.drzeus.cx>
	<46B6F877.7060504@csr.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Aug 2007 11:31:19 +0100
David Vrabel <david.vrabel@csr.com> wrote:

> 
> I would expect the block size to be set once per card, and never be
> changed and thus it's not logically a per-transfer operation.  We
> certainly wouldn't want to change the block size willy-nilly as it's
> an expensive operation.
> 

Indeed. It would of course be optimized so that it doesn't change the
size needlessly.

The beauty is that drivers wouldn't have to care. Things just
work<tm>. :)

> > I suspect that some transactions might require a certain block size.
> > But we could satisfy that by stating that any transfer small enough
> > to fit into one block will not be split up.
> 
> I consider it unlikely that any card would want to do anything other
> than always use the largest possible block size.
> 

I have a counter example. I have here a Marvell wifi card which needs a
firmware upload. And it seems to be rather picky about parameters
during that upload.

I'm still experimenting with a clean way to do things for this card.
I'll get back to you. :)

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
