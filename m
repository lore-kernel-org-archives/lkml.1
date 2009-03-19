Return-Path: <linux-kernel-owner+w=401wt.eu-S1759179AbZCSGUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759179AbZCSGUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 02:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755185AbZCSGUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 02:20:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47378
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755180AbZCSGUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 02:20:16 -0400
Date: Wed, 18 Mar 2009 23:20:03 -0700 (PDT)
Message-Id: <20090318.232003.30974750.davem@davemloft.net>
To: jpirko@redhat.com
Cc: shemminger@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jgarzik@pobox.com,
       bridge@lists.linux-foundation.org, fubar@us.ibm.com,
       bonding-devel@lists.sourceforge.net
Subject: Re: [PATCH] bonding: allow bond in mode balance-alb to work
 properly in bridge
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090316111127.GB3484@psychotron.englab.brq.redhat.com>
References: <20090314094911.GA3455@psychotron.englab.brq.redhat.com>
	<20090315161217.7fa2c3a7@nehalam>
	<20090316111127.GB3484@psychotron.englab.brq.redhat.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Pirko <jpirko@redhat.com>
Date: Mon, 16 Mar 2009 12:11:28 +0100

> I can see two solutions. Either like my patch or somehow allow bridge to know
> more MAC addressses per port (maybe netdev can be changed to know more then
> one MAC address).
> 
> Any thoughts?

The netdev struct already supports having a list of multiple unicast
MAC addresses, it can probably be used and inspected for this.

I'll hold off on your patch until we make some more progress on
this discussion.
