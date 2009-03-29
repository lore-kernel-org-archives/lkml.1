Return-Path: <linux-kernel-owner+w=401wt.eu-S1760038AbZC2Uy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760038AbZC2Uy0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 16:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756603AbZC2UyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 16:54:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50081
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754912AbZC2UyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 16:54:08 -0400
Date: Sun, 29 Mar 2009 13:53:55 -0700 (PDT)
Message-Id: <20090329.135355.109115565.davem@davemloft.net>
To: kaber@trash.net
Cc: jpirko@redhat.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jgarzik@pobox.com, shemminger@linux-foundation.org,
       bridge@lists.linux-foundation.org, fubar@us.ibm.com,
       bonding-devel@lists.sourceforge.net, mschmidt@redhat.com,
       dada1@cosmosbay.com
Subject: Re: [PATCH] bonding: allow bond in mode balance-alb to work
 properly in bridge -try4
From: David Miller <davem@davemloft.net>
In-Reply-To: <49CC85E9.7070903@trash.net>
References: <20090326155205.GA28868@psychotron.englab.brq.redhat.com>
	<20090327.003819.234492275.davem@davemloft.net>
	<49CC85E9.7070903@trash.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Fri, 27 Mar 2009 08:53:13 +0100

> David Miller wrote:
> > I don't like the hook, but if that's how it's best done....
> > Patrick, please review this.
> 
> Me neither, but I don't think this approach can be done without the
> hook. While I still find it questionable whether this mode really
> needs to be supported for a bridge at all, an alternative approach
> would be to have bonding add FDB entries for all secondary MACs to
> make bridging treat them as local.

Do you guys foresee any possibility of an alternative implementation
any time soon?

Otherwise we're just stalling by not putting something into the tree,
and as far as I can tell this patch here might as well be it.
