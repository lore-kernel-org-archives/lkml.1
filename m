Return-Path: <linux-kernel-owner+w=401wt.eu-S1753267AbYLARzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbYLARzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 12:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbYLARzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 12:55:23 -0500
Received: from lixom.net ([66.141.50.11]:41509 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbYLARzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 12:55:23 -0500
Date: Mon, 1 Dec 2008 12:08:12 -0600
From: Olof Johansson <olof@lixom.net>
To: Julia Lawall <julia@diku.dk>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drivers/mtd/nand/pasemi_nand.c: Add missing pci_dev_put
Message-ID: <20081201180812.GA21646@lixom.net>
References: <Pine.LNX.4.64.0811271319070.15160@pc-004.diku.dk> <20081201174327.GA21274@lixom.net> <Pine.LNX.4.64.0812011838440.11341@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812011838440.11341@pc-004.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2008 at 06:39:01PM +0100, Julia Lawall wrote:
> On Mon, 1 Dec 2008, Olof Johansson wrote:
> 
> > On Thu, Nov 27, 2008 at 01:19:49PM +0100, Julia Lawall wrote:
> > > From: Julia Lawall <julia@diku.dk>
> > > 
> > > pci_get_device increments a reference count that should be decremented
> > > using pci_dev_put.  I have thus added an extra label in the error handling
> > > code to do this.  I don't know, however, whether there should be a
> > > pci_dev_put before the return 0 as well.
> > > 
> > [...]
> > 
> > > Signed-off-by: Julia Lawall <julia@diku.dk>
> > 
> > Acked-by: Olof Johansson <olof@lixom.net>
> 
> Do you know the answer about the return 0?

Teaches me to read the patch description twice.

Either there or in pasemi_nand_remove(), doesn't matter much to me. Doing
it before the return 0 is the smaller change.


-Olof
