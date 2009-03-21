Return-Path: <linux-kernel-owner+w=401wt.eu-S1755648AbZCUU3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648AbZCUU3m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 16:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754034AbZCUU3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 16:29:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55783
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753625AbZCUU3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 16:29:30 -0400
Date: Sat, 21 Mar 2009 13:29:17 -0700 (PDT)
Message-Id: <20090321.132917.32958808.davem@davemloft.net>
To: richard@rsk.demon.co.uk
Cc: yoshfuji@linux-ipv6.org, pekkas@netcore.fi, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv6: reorder struct inet6_ifaddr to remove padding on
 64 bit builds
From: David Miller <davem@davemloft.net>
In-Reply-To: <1237476760.3266.13.camel@localhost.localdomain>
References: <1237476760.3266.13.camel@localhost.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Kennedy <richard@rsk.demon.co.uk>
Date: Thu, 19 Mar 2009 15:32:40 +0000

> reorder struct inet6_ifaddr to remove padding on 64 bit builds
>     
> remove 8 bytes of padding so inet6_ifaddr becomes 192 bytes & fits into
> a smaller slab.
>     
> Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

Applied, thanks.
