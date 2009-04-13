Return-Path: <linux-kernel-owner+w=401wt.eu-S1754054AbZDMWy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbZDMWy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 18:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbZDMWyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 18:54:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43351
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752922AbZDMWyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 18:54:45 -0400
Date: Mon, 13 Apr 2009 15:54:36 -0700 (PDT)
Message-Id: <20090413.155436.230187370.davem@davemloft.net>
To: shemminger@linux-foundation.org
Cc: jpirko@redhat.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jgarzik@pobox.com, bridge@lists.linux-foundation.org, fubar@us.ibm.com,
       bonding-devel@lists.sourceforge.net, kaber@trash.net,
       mschmidt@redhat.com, dada1@cosmosbay.com, ivecera@redhat.com
Subject: Re: [PATCH 2/4] net: introduce a list of device addresses
 dev_addr_list
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090413074917.4e317115@nehalam>
References: <20090413083729.GA23734@psychotron.englab.brq.redhat.com>
	<20090413084201.GC23734@psychotron.englab.brq.redhat.com>
	<20090413074917.4e317115@nehalam>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@linux-foundation.org>
Date: Mon, 13 Apr 2009 07:49:17 -0700

> This lock is unnecessary, use RCU list for read.
> Since all changes are under RTNL mutex, there is no chance
> for conflict on update.

Agreed.
