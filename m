Return-Path: <linux-kernel-owner+w=401wt.eu-S1762971AbZEHXAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762971AbZEHXAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 19:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbZEHXAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 19:00:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32884
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751209AbZEHXAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 19:00:14 -0400
Date: Fri, 08 May 2009 16:00:08 -0700 (PDT)
Message-Id: <20090508.160008.127530143.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: jpirko@redhat.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jgarzik@pobox.com, shemminger@linux-foundation.org,
       bridge@lists.linux-foundation.org, fubar@us.ibm.com,
       bonding-devel@lists.sourceforge.net, kaber@trash.net,
       mschmidt@redhat.com, dada1@cosmosbay.com, ivecera@redhat.com
Subject: Re: [PATCH] net: introduce a list of device addresses
 dev_addr_list (v6)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090508153842.65ce3bed@s6510>
References: <20090505124827.GB3473@psychotron.englab.brq.redhat.com>
	<20090505.122718.51237316.davem@davemloft.net>
	<20090508153842.65ce3bed@s6510>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Fri, 8 May 2009 15:38:42 -0700

> Not sure if this is such a good idea since the purpose of this was to fix
> a bonding/bridging interaction, but it breaks STP on bridging.

Thanks for not paying attention... :-/

The Intel folks want to have an address list functionality so
they can public MAC addresses meant for FCOE and other purposes.

So even if the bonding bits bomb, we still need this.
