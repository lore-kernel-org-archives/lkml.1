Return-Path: <linux-kernel-owner+w=401wt.eu-S1753686AbZI2AIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbZI2AIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 20:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbZI2AIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 20:08:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37271
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753632AbZI2AID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 20:08:03 -0400
Date: Mon, 28 Sep 2009 17:08:21 -0700 (PDT)
Message-Id: <20090928.170821.124026517.davem@davemloft.net>
To: sbhatewara@vmware.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       shemminger@linux-foundation.org, jgarzik@pobox.com,
       anthony@codemonkey.ws, chrisw@sous-sol.org, greg@kroah.com,
       akpm@linux-foundation.org, virtualization@lists.linux-foundation.org,
       pv-drivers@vmware.com
Subject: Re: [PATCH 2.6.31-rc9] net: VMware virtual Ethernet NIC driver:
 vmxnet3
From: David Miller <davem@davemloft.net>
In-Reply-To: <89E2752CFA8EC044846EB849981913410173CDFAF6@EXCH-MBX-4.vmware.com>
References: <89E2752CFA8EC044846EB849981913410173CDFAF6@EXCH-MBX-4.vmware.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shreyas Bhatewara <sbhatewara@vmware.com>
Date: Mon, 28 Sep 2009 16:56:45 -0700

> +       uint32_t rxdIdx:12;    /* Index of the RxDesc */

Don't use uint32_t et al. sized types, use "u32" and friends
throughout.
