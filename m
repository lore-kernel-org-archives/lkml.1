Return-Path: <linux-kernel-owner+w=401wt.eu-S1754983AbZG2Nqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbZG2Nqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755085AbZG2Nqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:46:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35144
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755565AbZG2Nqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:46:52 -0400
Date: Wed, 29 Jul 2009 06:46:59 -0700 (PDT)
Message-Id: <20090729.064659.193718905.davem@davemloft.net>
To: greg@kroah.com
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, kaber@trash.net
Subject: Re: linux-next: manual merge of the staging tree with the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090729124406.GA26931@kroah.com>
References: <20090729165211.c13f3ca3.sfr@canb.auug.org.au>
	<20090729124406.GA26931@kroah.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <greg@kroah.com>
Date: Wed, 29 Jul 2009 05:44:06 -0700

> On Wed, Jul 29, 2009 at 04:52:11PM +1000, Stephen Rothwell wrote:
>> Hi Greg,
>> 
>> Today's linux-next merge of the staging tree got a conflict in
>> drivers/staging/epl/VirtualEthernetLinux.c between commit
>> 6ed106549d17474ca17a16057f4c0ed4eba5a7ca ("net: use NETDEV_TX_OK instead
>> of 0 in ndo_start_xmit() functions") from the net tree and commit
>> 49acb975a21d150c4beba4e581f3e1d004dd2867 ("Staging: remove epl driver")
>> from the staging tree.
>> 
>> The latter just removes the file, so I did that.
> 
> Thanks a lot.  Yes, the epl driver has been dropped from staging, so
> that's the right thing to do.

Please make sure you integrate that change, if the driver is
simply moving out of staging to somewhere else.
