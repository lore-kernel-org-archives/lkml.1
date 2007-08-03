Return-Path: <linux-kernel-owner+w=401wt.eu-S1764539AbXHCRzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764539AbXHCRzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 13:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932876AbXHCRyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 13:54:38 -0400
Received: from gate.ebshome.net ([208.106.21.240]:34141 "EHLO gate.ebshome.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932870AbXHCRyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 13:54:36 -0400
Date: Fri, 3 Aug 2007 10:47:54 -0700
From: Eugene Surovegin <ebs@ebshome.net>
To: Yoann Padioleau <padator@wanadoo.fr>
Cc: kernel-janitors@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/13] dev->priv to netdev_priv(dev), for drivers/net/ibm_emac
Message-ID: <20070803174754.GA1352@gate.ebshome.net>
References: <200708031734.TAA00777@ifs.emn.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708031734.TAA00777@ifs.emn.fr>
X-ICQ-UIN: 1193073
X-Operating-System: Linux i686
X-PGP-Key: http://www.ebshome.net/pubkey.asc
User-Agent: Mutt/1.5.8i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 07:34:19PM +0200, Yoann Padioleau wrote:
> 
> Replacing accesses to dev->priv to netdev_priv(dev). The replacment
> is safe when netdev_priv is used to access a private structure that is
> right next to the net_device structure in memory. Cf
> http://groups.google.com/group/comp.os.linux.development.system/browse_thread/thread/de19321bcd94dbb8/0d74a4adcd6177bd
> This is the case when the net_device structure was allocated with
> a call to alloc_netdev or one of its derivative.

NAK.

While that assumption is correct for the actual emac net device, it's 
not for MAL poll one.

You patch breaks a working driver.

-- 
Eugene

