Return-Path: <linux-kernel-owner+w=401wt.eu-S1757777AbZDGPwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777AbZDGPwu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754300AbZDGPwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:52:40 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49693 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875AbZDGPwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:52:40 -0400
Message-ID: <49DB76BD.8090203@garzik.org>
Date: Tue, 07 Apr 2009 11:52:29 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] parport: Use the PCI IRQ if offered
References: <20090407143009.31233.22016.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090407143009.31233.22016.stgit@t61.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> PCI parallel port devices can IRQ share so we should stop them hogging the
> line and making a mess on modern PC systems. We know the sharing side works
> as the PCMCIA driver has shared the parallel port IRQ for some time.
> 
> Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
> ---
> 
>  drivers/parport/parport_cs.c     |    3 +-
>  drivers/parport/parport_pc.c     |   57 ++++++++++++++++++++++++--------------
>  drivers/parport/parport_serial.c |   20 +++++++++++--
>  include/linux/parport_pc.h       |   11 ++++---
>  4 files changed, 60 insertions(+), 31 deletions(-)

Acked-by: Jeff Garzik <jgarzik@pobox.com>

(I did some parport work many years ago, trying to improve the parport 
driver's integration with modern on-mainboard parallel port controls; 
this was one of the goals, only now realized)


