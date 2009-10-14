Return-Path: <linux-kernel-owner+w=401wt.eu-S1762048AbZJNWLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762048AbZJNWLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 18:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755658AbZJNWLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 18:11:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47129
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754086AbZJNWLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 18:11:10 -0400
Date: Wed, 14 Oct 2009 15:11:06 -0700 (PDT)
Message-Id: <20091014.151106.138362225.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, david.choi@micrel.com
Subject: Re: [PATCH -mmotm] net: ks8851_mll uses mii interfaces
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091014145905.219416bb.randy.dunlap@oracle.com>
References: <200910140436.n9E4aF9G001644@imap1.linux-foundation.org>
	<20091014145905.219416bb.randy.dunlap@oracle.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Wed, 14 Oct 2009 14:59:05 -0700

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> ks8851_mll uses mii interfaces so it needs to select MII.
> 
> ks8851_mll.c:(.text+0xf95ac): undefined reference to `generic_mii_ioctl'
> ks8851_mll.c:(.text+0xf96a0): undefined reference to `mii_ethtool_gset'
> ks8851_mll.c:(.text+0xf96fa): undefined reference to `mii_ethtool_sset'
> ks8851_mll.c:(.text+0xf9754): undefined reference to `mii_link_ok'
> ks8851_mll.c:(.text+0xf97ae): undefined reference to `mii_nway_restart'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: David Choi <david.choi@micrel.com>

Applied, thanks Randy.
