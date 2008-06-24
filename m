Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbYFXBh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbYFXBh4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 21:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbYFXBht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 21:37:49 -0400
Received: from mail.queued.net ([207.210.101.209]:3604 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413AbYFXBhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 21:37:48 -0400
Date: Mon, 23 Jun 2008 21:40:27 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: drzeus-sdhci@drzeus.cx, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [OLPC] sdhci: add quirk for the Marvell CaFe's
 interrupt timeout
Message-ID: <20080623214027.7f3e0521@xo-debian>
In-Reply-To: <20080623170449.6567d857.akpm@linux-foundation.org>
References: <20080623101352.3bbaf5b0@xo-debian>
	<20080623170449.6567d857.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2008 17:04:49 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 23 Jun 2008 10:13:52 -0400
> Andres Salomon <dilinger@queued.net> wrote:
> 
> > 
> > The CaFe chip has a hardware bug that ends up with us getting a
> > timeout value that's too small, causing the following sorts of
> > problems:
> > 
> > [   60.525138] mmcblk0: error -110 transferring data
> > [   60.531477] end_request: I/O error, dev mmcblk0, sector 1484353
> > [   60.533371] Buffer I/O error on device mmcblk0p2, logical block
> > 181632 [   60.533371] lost page write due to I/O error on mmcblk0p2
> > 
[...]
> 
> This is needed in 2.6.26, I assume?
> 


Yes, please.


> If so, I can merge it unless Pierre has objections?
> 
> And it will cause conflicts with overlapping changes in linux-next.
> 
