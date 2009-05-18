Return-Path: <linux-kernel-owner+w=401wt.eu-S1754971AbZERBpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971AbZERBpz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 21:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbZERBpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 21:45:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:15768 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731AbZERBpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 21:45:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,208,1241420400"; 
   d="scan'208";a="516402977"
Subject: Re: [PATCH 1/3] drivers/net: use dev_get_drvdata
From: Zhu Yi <yi.zhu@intel.com>
To: Julia Lawall <julia@diku.dk>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0905171128140.20440@pc-004.diku.dk>
References: <Pine.LNX.4.64.0905171128140.20440@pc-004.diku.dk>
Content-Type: text/plain
Date: Mon, 18 May 2009 09:38:16 +0800
Message-Id: <1242610696.24825.462.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-05-17 at 17:28 +0800, Julia Lawall wrote:
> 
> From: Julia Lawall <julia@diku.dk>
> 
> Eliminate direct accesses to the driver_data field.
> cf 82ab13b26f15f49be45f15ccc96bfa0b81dfd015
> 
> The semantic patch that makes this change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @@
> struct device *dev;
> expression E;
> type T;
> @@
> 
> - dev->driver_data = (T)E
> + dev_set_drvdata(dev, E)
> 
> @@
> struct device *dev;
> type T;
> @@
> 
> - (T)dev->driver_data
> + dev_get_drvdata(dev)
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Zhu Yi <yi.zhu@intel.com>

Thanks,
-yi

