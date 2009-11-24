Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbZKXBTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbZKXBTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 20:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbZKXBTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 20:19:55 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:47282 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbZKXBTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 20:19:54 -0500
Date: Tue, 24 Nov 2009 01:19:58 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alexander Beregalov <a.beregalov@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Florian Fainelli <florian@openwrt.org>, linux-mips@linux-mips.org,
       Manuel Lauss <manuel.lauss@googlemail.com>
Subject: Re: linux-next: manual merge of the mips tree with the net-current
	tree
Message-ID: <20091124011958.GA8105@linux-mips.org>
References: <20091124113717.c5d86d41.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091124113717.c5d86d41.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 11:37:17AM +1100, Stephen Rothwell wrote:

> Hi Ralf,
> 
> Today's linux-next merge of the mips tree got a conflict in
> drivers/net/au1000_eth.c between commit
> 63edaf647607795a065e6956a79c47f500dc8447 ("Au1x00: fix crash when trying
> register_netdev()") from the net-current tree and commit
> 6cdbc95856e7f4ab4e7b2f2bdab5c3844537ad83 ("NET: au1000-eth: convert to
> platform_driver model") from the mips tree.
> 
> It looks to me that the mips tree change supercedes the net-current one
> (since it moves the register_netdev() call much later), so I just used
> this file from the mips tree.

I agree.  David, can you just drop the net-current patch then?  This fix
is still needed for -stable however.

  Ralf
