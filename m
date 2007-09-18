Return-Path: <linux-kernel-owner+w=401wt.eu-S1758104AbXIRTIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104AbXIRTIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 15:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755651AbXIRTIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 15:08:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51619
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752355AbXIRTIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 15:08:45 -0400
Date: Tue, 18 Sep 2007 12:08:44 -0700 (PDT)
Message-Id: <20070918.120844.89387648.davem@davemloft.net>
To: mel@skynet.ie
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       themann@de.ibm.com
Subject: Re: 2.6.23-rc6-mm1: Build failure on ppc64
 drivers/net/ehea/ehea_main.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070918162039.GA1804@skynet.ie>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	<20070918162039.GA1804@skynet.ie>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: mel@skynet.ie (Mel Gorman)
Date: Tue, 18 Sep 2007 17:20:39 +0100

> Hi Andrew,
> 
> PPC64 failed to build with the driver drivers/net/ehea with the
> following error
> 
>   CC [M]  drivers/net/ehea/ehea_main.o
> drivers/net/ehea/ehea_main.c: In function `ehea_open':
> drivers/net/ehea/ehea_main.c:2322: error: implicit declaration of function `port_napi_enable'
> drivers/net/ehea/ehea_main.c: At top level:
> drivers/net/ehea/ehea_main.c:2340: error: conflicting types for 'port_napi_enable'
> drivers/net/ehea/ehea_main.c:2322: error: previous implicit declaration of 'port_napi_enable' was here
> make[1]: *** [drivers/net/ehea/ehea_main.o] Error 1
> 
> It's buried in git-net.patch and I've cc'd a potential owner based simply
> on the mention of EHEA in a leader. I've included a candidate fix for the
> error. It seems to be a simple case of port_napi_enable being defined in
> the wrong place.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Thanks for this fix, I'll merge it into the net-2.6.24 tree.
