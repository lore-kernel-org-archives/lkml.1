Return-Path: <linux-kernel-owner+w=401wt.eu-S1756944AbZIDOyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944AbZIDOyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 10:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756891AbZIDOyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 10:54:31 -0400
Received: from kroah.org ([198.145.64.141]:56621 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452AbZIDOya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 10:54:30 -0400
Date: Fri, 4 Sep 2009 07:52:06 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@vyatta.com>,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: manual merge of the staging tree with the net tree
Message-ID: <20090904145206.GA15964@kroah.com>
References: <20090904173225.0817003b.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904173225.0817003b.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04, 2009 at 05:32:25PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/at76_usb/at76_usb.c between commits
> 6ed106549d17474ca17a16057f4c0ed4eba5a7ca ("net: use NETDEV_TX_OK instead
> of 0 in ndo_start_xmit() functions") and
> 0fc0b732eaa38beb93a6fb62f77c7bd9622c76ec ("netdev: drivers should make
> ethtool_ops const") from the net tree and commit
> c0e03fabb4f2a6e48f6e0b55729b26a599a2bd02 ("Staging: remove at76_usb
> wireless driver") from the staging tree.
> 
> The latter just removes the driver, so I did that.

Thanks, that's an easy fix :)

greg k-h
