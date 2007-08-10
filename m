Return-Path: <linux-kernel-owner+w=401wt.eu-S937853AbXHJNht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937853AbXHJNht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 09:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932932AbXHJNhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 09:37:35 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:47798 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117AbXHJNhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 09:37:33 -0400
Date: Fri, 10 Aug 2007 15:37:31 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: David Vrabel <david.vrabel@csr.com>
Cc: linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Subject: Re: sdio: add <linux/mmc/sdio_csr.h> for CSR specific CCCR
 registers
Message-ID: <20070810153731.7b092bb0@poseidon.drzeus.cx>
In-Reply-To: <46BC59E2.9060102@csr.com>
References: <46BC58E8.50300@csr.com>
	<46BC59E2.9060102@csr.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007 13:28:18 +0100
David Vrabel <david.vrabel@csr.com> wrote:

> sdio: add <linux/mmc/sdio_csr.h> for CSR specific CCCR registers
> 
> Signed-off-by: David Vrabel <david.vrabel@csr.com>

I'm not a fan of this trend of sticking device specific headers in
include/linux, but if it's for registers common to many devices spread
all over the kernel tree, then I suppose it's acceptable.

I'm not going to apply this just yet though as it isn't used. Include
it with the first driver that needs it.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
