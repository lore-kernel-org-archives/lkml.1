Return-Path: <linux-kernel-owner+w=401wt.eu-S1759506AbXIJR7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759506AbXIJR7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 13:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755620AbXIJR7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 13:59:15 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:41485 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381AbXIJR7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 13:59:14 -0400
Date: Mon, 10 Sep 2007 17:58:08 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Garzik <jgarzik@pobox.com>,
       netdev@vger.kernel.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sb1250-mac.c: De-typedef, de-volatile, de-etc...
Message-ID: <20070910165808.GA7501@linux-mips.org>
References: <Pine.LNX.4.64N.0709101310030.25038@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64N.0709101310030.25038@blysk.ds.pg.gda.pl>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2007 at 01:20:38PM +0100, Maciej W. Rozycki wrote:

>  Remove typedefs, volatiles and convert kmalloc()/memset() pairs to
> kcalloc().  Also reformat the surrounding clutter.
> 
> Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
> ---
>  Per your request, Andrew, a while ago.  It builds, runs, passes 
> checkpatch.pl and sparse.  No semantic changes.

One step closer to sanity for this driver.  So it's got my ACK.

  Ralf
