Return-Path: <linux-kernel-owner+w=401wt.eu-S1761375AbXKBVUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761375AbXKBVUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 17:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758282AbXKBVUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 17:20:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36119
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757346AbXKBVUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 17:20:03 -0400
Date: Fri, 02 Nov 2007 14:20:02 -0700 (PDT)
Message-Id: <20071102.142002.56666600.davem@davemloft.net>
To: djohnson+linux-kernel@sw.starentnetworks.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       bguo@sw.starentnetworks.com, mchan@broadcom.com
Subject: Re: expected behavior of PF_PACKET on NETIF_F_HW_VLAN_RX device?
From: David Miller <davem@davemloft.net>
In-Reply-To: <18219.26528.485099.317944@zeus.sw.starentnetworks.com>
References: <4729EAFF.9050606@candelatech.com>
	<18218.18134.353553.189622@zeus.sw.starentnetworks.com>
	<18219.26528.485099.317944@zeus.sw.starentnetworks.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com>
Date: Fri, 2 Nov 2007 14:08:32 -0400

> These changes seems to cause this issue:
> 
> >  [BNX2]: Fix VLAN on ASF
> >  
> >  Always set up the device to strip incoming VLAN tags when ASF is
> >  enabled. ASF firmware will not parse packets correctly if VLAN tags
> >  are not stripped.
> >  
> >  Signed-off-by: Michael Chan <mchan@broadcom.com>
> >  Signed-off-by: David S. Miller <davem@davemloft.net>
> >  
> >  GIT: e29054f92d7d575631691865c1b95bee5bc974cc
> 
> and
> 
> > ChangeSet@1.1371.72.2, 2003-12-02 02:34:13-08:00, davem@nuts.ninka.net +1 -0
> >   [TG3]: Do not set RX_MODE_KEEP_VLAN_TAG when ASF is enabled.
> 
> 
> Could you elaborate if this is really needed, if so is there some
> workaround that could be done instead?
> 
> Simply removing the check seemed to work for me, but I'm unsure if
> this is actually a valid thing to do with these MACs.

Unfortunately the ASF firmware is very picky.

I think were are stuck with this behavior.
