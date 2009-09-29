Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbZI2BQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbZI2BQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 21:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753817AbZI2BQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 21:16:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55918
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753734AbZI2BQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 21:16:44 -0400
Date: Mon, 28 Sep 2009 18:17:02 -0700 (PDT)
Message-Id: <20090928.181702.41922043.davem@davemloft.net>
To: akataria@vmware.com
Cc: greg@kroah.com, sbhatewara@vmware.com, pv-drivers@vmware.com,
       netdev@vger.kernel.org, shemminger@linux-foundation.org,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       chrisw@sous-sol.org, anthony@codemonkey.ws, akpm@linux-foundation.org,
       jgarzik@pobox.com
Subject: Re: [Pv-drivers] [PATCH 2.6.31-rc9] net: VMware virtual Ethernet
 NIC driver: vmxnet3
From: David Miller <davem@davemloft.net>
In-Reply-To: <1254185499.13456.40.camel@ank32.eng.vmware.com>
References: <89E2752CFA8EC044846EB849981913410173CDFAF6@EXCH-MBX-4.vmware.com>
	<20090929002207.GB31372@kroah.com>
	<1254185499.13456.40.camel@ank32.eng.vmware.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alok Kataria <akataria@vmware.com>
Date: Mon, 28 Sep 2009 17:51:39 -0700

> As a side note, were there any changes in the networking API's, that we
> should look out for in the merge cycle ?
> If not I think the rebase should be pretty trivial.

Just off the top of my head, the return type of the driver transmit
function was changed to netdev_tx_t, for one thing.

But there were likely numerous others.  You'll have to check.
