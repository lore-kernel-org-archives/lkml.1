Return-Path: <linux-kernel-owner+w=401wt.eu-S1765582AbXFRVW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765582AbXFRVW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 17:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762005AbXFRVWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 17:22:48 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:37449 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759098AbXFRVWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 17:22:47 -0400
Date: Mon, 18 Jun 2007 16:22:38 -0500
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] ide dma_timer_expiry, then hard lockup
Message-ID: <20070618212238.GI5836@austin.ibm.com>
References: <20070618175713.GD5836@austin.ibm.com> <20070618212704.394912b8@the-village.bc.nu> <20070618204601.GF5836@austin.ibm.com> <20070618220441.3a3af8ca@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618220441.3a3af8ca@the-village.bc.nu>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 10:04:41PM +0100, Alan Cox wrote:
> 
> If you've got a nice repeatable problem 

Very highly repeatable :-(

> please try using the libata
> driver. That handles the error paths differently and doesn't try a FIFO
> drain which might matter in this case I guess.

Dohh, yes, of course. Completely forgot about that. (I assume you mean 
CONFIG_ATA).  Will report tommorrow.

--linas
