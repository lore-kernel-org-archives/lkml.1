Return-Path: <linux-kernel-owner+w=401wt.eu-S1757831AbZLKNmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831AbZLKNmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 08:42:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757859AbZLKNly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 08:41:54 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33726 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757449AbZLKNlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 08:41:51 -0500
Date: Fri, 11 Dec 2009 13:42:36 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>,
       Roger Quadros <quadros.roger@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Shargorodsky Atal <ext-atal.shargorodsky@nokia.com>
Subject: Re: [PATCH] kfifo: add DMA capabilities
Message-ID: <20091211134236.7b9af57b@lxorguk.ukuu.org.uk>
In-Reply-To: <1260538589.3925.11.camel@wall-e>
References: <1260538589.3925.11.camel@wall-e>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Dec 2009 14:36:29 +0100
Stefani Seibold <stefani@seibold.net> wrote:

> As requested by Shargorodsky Atal:
> 
> This patch adds functions for DMA handling to the new kfifo API. 
> 
> To prepare a DMA one of the kfifo_dma_..._prepare() Funktions must be
> called. This results in a scatterlist structure which can passed to the
> kernel DMA functions.

Looks good to me - the tty buffering has similar functions to some bits
of this for the same reasons.

Alan
