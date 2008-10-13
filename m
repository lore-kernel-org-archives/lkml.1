Return-Path: <linux-kernel-owner+w=401wt.eu-S1758290AbYJMSKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290AbYJMSKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 14:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756856AbYJMSKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 14:10:12 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:43923 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756767AbYJMSKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 14:10:10 -0400
Cc: Lennert Buytenhek <buytenh@marvell.com>, jgarzik@pobox.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Message-Id: <5281FCAB-128C-4AE7-8241-BF748B1911CF@freescale.com>
From: Andy Fleming <afleming@freescale.com>
To: Adrian Bunk <bunk@kernel.org>
In-Reply-To: <20081013171900.GK29938@cs181140183.pp.htv.fi>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [2.6 patch] export genphy_restart_aneg
Date: Mon, 13 Oct 2008 13:04:30 -0500
References: <20081013171900.GK29938@cs181140183.pp.htv.fi>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 13, 2008, at 12:19, Adrian Bunk wrote:

> This patch fixes the following build error caused by
> commit ed94493fb38a665cebcf750dfabe8a6dd13e136f
> (mv643xx_eth: convert to phylib):
>
> <--  snip  -->
>
> ...
>  Building modules, stage 2.
>  MODPOST 1280 modules
> ERROR: "genphy_restart_aneg" [drivers/net/mv643xx_eth.ko] undefined!
> ...
> make[2]: *** [__modpost] Error 1
>
> <--  snip  -->
>
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>


Could you get genphy_setup_forced, too?  It doesn't appear to be used,  
but it's currently in include/linux/phy.h, and not static.

Alternatively, we could change genphy_setup_forced to be static.  :)

Andy
