Return-Path: <linux-kernel-owner+w=401wt.eu-S1752204AbYE1OUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbYE1OUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 10:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYE1OUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 10:20:46 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62875 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751211AbYE1OUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 10:20:46 -0400
Date: Wed, 28 May 2008 15:15:10 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
cc: Timur Tabi <timur@freescale.com>, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [SERIAL] fix driver_name conflicts
In-Reply-To: <20080526172340.GA17703@polina.dev.rtsoft.ru>
Message-ID: <Pine.LNX.4.55.0805281511160.29522@cliff.in.clinika.pl>
References: <20080526172340.GA17703@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2008, Anton Vorontsov wrote:

> This patch fixes two drivers that are using "serial" for driver_name and
> not "ttyS" for dev_name. Drivers that are using "ttyS" for dev_name, will
> conflict anyway, so we don't bother with these.
> 
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
>  drivers/serial/sb1250-duart.c |    2 +-
>  drivers/serial/ucc_uart.c     |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

 Not that it makes much sense to have both included in the same kernel,
but for the purpose of purity:

Acked-by: Maciej W. Rozycki <macro@linux-mips.org>

  Maciej
