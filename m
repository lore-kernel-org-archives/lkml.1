Return-Path: <linux-kernel-owner+w=401wt.eu-S1759966AbZCMXMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759966AbZCMXMn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 19:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbZCMXMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 19:12:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46450
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751998AbZCMXMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 19:12:31 -0400
Date: Fri, 13 Mar 2009 16:12:17 -0700 (PDT)
Message-Id: <20090313.161217.52045656.davem@davemloft.net>
To: jesper@krogh.cc
Cc: fubar@us.ibm.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jgarzik@redhat.com, aowi@novozymes.com
Subject: Re: Regression in bonding between 2.6.26.8 and 2.6.27.6 - bisected
 - twice
From: David Miller <davem@davemloft.net>
In-Reply-To: <49B581D3.6060807@krogh.cc>
References: <49AA8B4F.8090405@krogh.cc>
	<9712.1236279072@death.nxdomain.ibm.com>
	<49B581D3.6060807@krogh.cc>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Krogh <jesper@krogh.cc>
Date: Mon, 09 Mar 2009 21:53:39 +0100

> Jay Vosburgh wrote:
> > 	However, I did find another bug I introduced during the "mii
> > refactor" patch that you mentioned as being the original source of the
> > problem.  That bug will cause 802.3ad to not notice speed changes.
> > 	Could you test the patch below on your 2.6.68.7 and/or 2.6.27.19
> > and see if it resolves your problem (without the forcedeth patch)?
> 
> There was something missing from the header to make it compile.. I found that in a later version. Patch below fixed the problem (without the forcedeth patch).

Jay please resend this with proper signoffs etc. if you want
me to apply it.
