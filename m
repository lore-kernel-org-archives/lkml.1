Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbZG2M6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbZG2M6v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 08:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755064AbZG2M6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 08:58:49 -0400
Received: from kroah.org ([198.145.64.141]:47853 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755219AbZG2M6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 08:58:47 -0400
Date: Wed, 29 Jul 2009 05:44:06 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: manual merge of the staging tree with the net tree
Message-ID: <20090729124406.GA26931@kroah.com>
References: <20090729165211.c13f3ca3.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090729165211.c13f3ca3.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 04:52:11PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/epl/VirtualEthernetLinux.c between commit
> 6ed106549d17474ca17a16057f4c0ed4eba5a7ca ("net: use NETDEV_TX_OK instead
> of 0 in ndo_start_xmit() functions") from the net tree and commit
> 49acb975a21d150c4beba4e581f3e1d004dd2867 ("Staging: remove epl driver")
> from the staging tree.
> 
> The latter just removes the file, so I did that.

Thanks a lot.  Yes, the epl driver has been dropped from staging, so
that's the right thing to do.

greg k-h
