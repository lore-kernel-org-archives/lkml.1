Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804Ab0ARPP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab0ARPP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 10:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753648Ab0ARPP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 10:15:57 -0500
Received: from casper.infradead.org ([85.118.1.10]:37280 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab0ARPP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 10:15:57 -0500
Date: Mon, 18 Jan 2010 07:16:07 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Felix Rubinstein <felixru@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: /dev/mem implementation
Message-ID: <20100118071607.17d954a2@infradead.org>
In-Reply-To: <af0693f01001180418h6344e4b2v64f82e54ab3d9241@mail.gmail.com>
References: <af0693f01001170847r49083075hc538a42b6bcd65ab@mail.gmail.com>
	<20100117094043.0483ee1a@infradead.org>
	<af0693f01001180418h6344e4b2v64f82e54ab3d9241@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jan 2010 14:18:22 +0200
Felix Rubinstein <felixru@gmail.com> wrote:

> The usecase is broadcom 10GbE switch driver which maps DMA memory to
> userspace. I can find one more libe1000 which uses char driver to map
> DMA memory to userspace too.
> So, how can I implement userspace drivers in recent kernels which want
> to map DMA memory to userspace if STRICT_DEVMEM or PAT (either of
> them) are enabled.

for these cases the driver should provide it's own mmap method that
exposes only those pages that the hardware has access to. You need
something like this anyway to deal with the dma mapping api....



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
