Return-Path: <linux-kernel-owner+w=401wt.eu-S937853AbXHJNkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937853AbXHJNkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 09:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938378AbXHJNi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 09:38:57 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:47798 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938368AbXHJNi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 09:38:57 -0400
Date: Fri, 10 Aug 2007 15:38:54 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: David Vrabel <david.vrabel@csr.com>
Cc: linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [patch 5/5] sdio: add sdio_f0_readb() and sdio_f0_writeb()
Message-ID: <20070810153854.6e34f0a7@poseidon.drzeus.cx>
In-Reply-To: <46BC5A3A.2030301@csr.com>
References: <46BC58E8.50300@csr.com>
	<46BC5A3A.2030301@csr.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007 13:29:46 +0100
David Vrabel <david.vrabel@csr.com> wrote:

> sdio: add sdio_f0_readb() and sdio_f0_writeb()
> 
> Add sdio_f0_readb() and sdio_f0_writeb() functions to reading and
> writing function 0 registers.  Writes outside the vendor specific CCCR
> registers (0xF0 - 0xFF) are not permitted.
> 
> Signed-off-by: David Vrabel <david.vrabel@csr.com>

Nice. Especially the touch with restricting it to vendor specific
regs. :)

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
