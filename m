Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029AbZI2TzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbZI2TzN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 15:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939AbZI2TzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 15:55:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48142
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753925AbZI2TzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 15:55:12 -0400
Date: Tue, 29 Sep 2009 12:55:30 -0700 (PDT)
Message-Id: <20090929.125530.31894576.davem@davemloft.net>
To: bhavesh@vmware.com
Cc: arnd@arndb.de, chrisw@sous-sol.org, pv-drivers@vmware.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, greg@kroah.com,
       anthony@codemonkey.ws, jgarzik@pobox.com, akpm@linux-foundation.org,
       shemminger@linux-foundation.org
Subject: Re: [Pv-drivers] [PATCH 2.6.31-rc9] net: VMware virtual Ethernet
 NIC driver: vmxnet3
From: David Miller <davem@davemloft.net>
In-Reply-To: <8B1F619C9F5F454E81D90D3C161698D7017DB76582@EXCH-MBX-3.vmware.com>
References: <20090929085333.GC3958@sequoia.sous-sol.org>
	<200909291505.50961.arnd@arndb.de>
	<8B1F619C9F5F454E81D90D3C161698D7017DB76582@EXCH-MBX-3.vmware.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bhavesh Davda <bhavesh@vmware.com>
Date: Tue, 29 Sep 2009 12:52:05 -0700

>> One thing that should possibly be fixed is the naming of identifiers,
>> e.g.
>> 's/Vmxnet3_MiscConf/vmxnet3_misc_conf/g', unless these header files are
>> shared with the host implementation.
> 
> These header files are indeed shared with the host implementation, as you've guessed. If it's not a big deal, we would like to keep the names the same, just for our own sanity's sake?

No.  This isn't your source tree, it's everyone's.  So you should
adhere to basic naming conventions and coding standards of the
tree regardless of what you happen to use or need to use internally.
