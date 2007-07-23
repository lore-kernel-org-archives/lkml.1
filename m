Return-Path: <linux-kernel-owner+w=401wt.eu-S1758487AbXGWVQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487AbXGWVQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 17:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbXGWVP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 17:15:57 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:38797 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbXGWVP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 17:15:56 -0400
Date: Tue, 24 Jul 2007 06:15:31 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <lkmladrian@gmail.com>
Cc: linux-kernel@vger.kernel.org, adrian@mcmen.demon.co.uk
Subject: Re: [PATCH] Fix Dreamcast DMA issues
Message-ID: <20070723211531.GB20049@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <lkmladrian@gmail.com>,
	linux-kernel@vger.kernel.org, adrian@mcmen.demon.co.uk
References: <8b67d60707231405l514c1b87t6ad3f8890f5d83ba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b67d60707231405l514c1b87t6ad3f8890f5d83ba@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 10:05:46PM +0100, Adrian McMenamin wrote:
> The current SH DMA API is somewhat broken, not correctly matching
> virtual channel to the correct SH DMAC. This wasn't noticeable when
> using g2 DMA for the sound driver - one channel 0 is as good as any
> other! - but caused the pvr2 driver to fail.
> 
> This patch fixes the pvr2 problem and consequently fixes the sound
> driver to ensure it continues to function.
> 
> Signed-off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

Looks fine, I'll queue it up, thanks.
