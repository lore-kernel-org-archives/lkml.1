Return-Path: <linux-kernel-owner+w=401wt.eu-S1753771AbYLARh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbYLARh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 12:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbYLARhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 12:37:17 -0500
Received: from lixom.net ([66.141.50.11]:37772 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbYLARhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 12:37:15 -0500
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Dec 2008 12:37:15 EST
Date: Mon, 1 Dec 2008 11:43:27 -0600
From: Olof Johansson <olof@lixom.net>
To: Julia Lawall <julia@diku.dk>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drivers/mtd/nand/pasemi_nand.c: Add missing pci_dev_put
Message-ID: <20081201174327.GA21274@lixom.net>
References: <Pine.LNX.4.64.0811271319070.15160@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0811271319070.15160@pc-004.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 01:19:49PM +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> pci_get_device increments a reference count that should be decremented
> using pci_dev_put.  I have thus added an extra label in the error handling
> code to do this.  I don't know, however, whether there should be a
> pci_dev_put before the return 0 as well.
> 
[...]

> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Olof Johansson <olof@lixom.net>

