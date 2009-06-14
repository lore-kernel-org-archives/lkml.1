Return-Path: <linux-kernel-owner+w=401wt.eu-S1752742AbZFNGhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbZFNGhl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 02:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbZFNGhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 02:37:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46401
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751835AbZFNGhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 02:37:34 -0400
Date: Sat, 13 Jun 2009 23:37:37 -0700 (PDT)
Message-Id: <20090613.233737.178725457.davem@davemloft.net>
To: slapin@ossfans.org
Cc: randy.dunlap@oracle.com, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, dbaryshkov@gmail.com,
       linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH -next] ieee802154: fix kconfig bool/tristate muckup
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090613105753.GB14520@build.ossfans.org>
References: <4A31869B.3050901@oracle.com>
	<4A32DDC8.7060605@oracle.com>
	<20090613105753.GB14520@build.ossfans.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergey Lapin <slapin@ossfans.org>
Date: Sat, 13 Jun 2009 14:57:54 +0400

> On Fri, Jun 12, 2009 at 03:59:20PM -0700, Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>> 
>> menuconfig IEEE802154_DRIVERS is a bool that depends on tristate IEEE802154.
>> If the IEEE802154 symbol is 'm', the bool becomes 'y'.
>> This allows tristate symbols under IEEE802154_DRIVERS to be configured as
>> 'y' and cause build problems.
>> Changing the menuconfig bool to a tristate fixes this.
>> 
>> drivers/built-in.o: In function `fake_scan_req':
>> fakehard.c:(.text+0x46d625): undefined reference to `ieee802154_nl_scan_confirm'
>> drivers/built-in.o: In function `fake_disassoc_req':
>> fakehard.c:(.text+0x46d66f): undefined reference to `ieee802154_nl_disassoc_confirm'
>> drivers/built-in.o: In function `fake_assoc_req':
>> fakehard.c:(.text+0x46d6be): undefined reference to `ieee802154_nl_assoc_confirm'
>> 
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>> Cc: linux-zigbee-devel@lists.sourceforge.net
>> Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
>> Cc: Sergey Lapin <slapin@ossfans.org>
> Ackedy-by: Sergey Lapin <slapin@ossfans.org>

It's "Acked-by:" :-)

Applied, thanks everyone.
