Return-Path: <linux-kernel-owner+w=401wt.eu-S1755377AbYJXRgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbYJXRgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 13:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbYJXRgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 13:36:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40321 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbYJXRgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 13:36:12 -0400
Date: Fri, 24 Oct 2008 15:36:01 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Markus Rechberger" <mrechberger@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       em28xx <em28xx@mcentral.de>
Subject: Re: [PATCH 2/7] adding latest xc3028 driver
Message-ID: <20081024153601.2de4c204@pedra.chehab.org>
In-Reply-To: <d9def9db0810221403u75ebab59k71c6e9f81eaaabe4@mail.gmail.com>
References: <d9def9db0810221403u75ebab59k71c6e9f81eaaabe4@mail.gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008 23:03:54 +0200
"Markus Rechberger" <mrechberger@gmail.com> wrote:

>     xc3028_module.c:
>     wrapper for the linux dvb frontend API
>     xc3028fw_helper.c:
>     firmware helper in order to align the raw videoblob to the
> corresponding standard.
>     xc3028_control.c:
>     Xceive core tuning driver
> 
>     the driver uses the tunerchip.h callbacks in order to only attach
> once in the em28xx-video file
>     for multistandard devices.
>     FM Radio, AnalogTV standards and Digital TV standards are tested.
> 
>     There are 2 firmwares xc3028 and xc3028L, both are merged into one
> firmware blob which
>     is available on mcentral.de
> 
>     This driver is part of the standalone em28xx driver which is also
> target'ed to work without any framework upgrades
>     on the eeePC (kernel 2.6.21), it's the latest reference driver from Xceive.

NACK. There's already a driver for xc3028 that works properly.

Cheers,
Mauro
