Return-Path: <linux-kernel-owner+w=401wt.eu-S1754371AbZEEEhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbZEEEhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 00:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbZEEEhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 00:37:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51243
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750965AbZEEEhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 00:37:35 -0400
Date: Mon, 04 May 2009 21:37:30 -0700 (PDT)
Message-Id: <20090504.213730.131875923.davem@davemloft.net>
To: jpirko@redhat.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, jgarzik@pobox.com,
       shemminger@linux-foundation.org, bridge@lists.linux-foundation.org,
       fubar@us.ibm.com, bonding-devel@lists.sourceforge.net, kaber@trash.net,
       mschmidt@redhat.com, dada1@cosmosbay.com, ivecera@redhat.com
Subject: Re: [PATCH] net: introduce a list of device addresses
 dev_addr_list (v5)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090504111417.GE3402@psychotron.englab.brq.redhat.com>
References: <20090417115723.GE9556@psychotron.englab.brq.redhat.com>
	<20090418085848.GC3370@psychotron.englab.brq.redhat.com>
	<20090504111417.GE3402@psychotron.englab.brq.redhat.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Pirko <jpirko@redhat.com>
Date: Mon, 4 May 2009 13:14:18 +0200

> +static void __hw_addr_del_multiple(struct list_head *to_list,
> +				   struct list_head *from_list,
> +				   int addr_len, unsigned char addr_type)
> +{
> +	__hw_addr_del_multiple_ii(to_list, from_list, addr_len, addr_type, -1);
> +}

Unused static function, this will create build warnings.

Or, it should :-)

If you plan to use such a function in subsequent patches, add
it in those changes not here.

Otherwise I have no fundamental objection to this patch, nice
work!
