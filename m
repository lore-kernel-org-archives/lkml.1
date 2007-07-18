Return-Path: <linux-kernel-owner+w=401wt.eu-S1760777AbXGRJjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760777AbXGRJjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 05:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbXGRJjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 05:39:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34583
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751626AbXGRJjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 05:39:24 -0400
Date: Wed, 18 Jul 2007 02:39:23 -0700 (PDT)
Message-Id: <20070718.023923.124552237.davem@davemloft.net>
To: cornelia.huck@de.ibm.com
Cc: linux-netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       netfilter-devel@lists.netfilter.org, jengelh@linux01.gwdg.de,
       kaber@trash.net
Subject: Re: [PATCH] netfilter: xt_connlimit needs to depend on nf_conntrack
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070716125352.3525ec5b@gondolin.boeblingen.de.ibm.com>
References: <20070716125352.3525ec5b@gondolin.boeblingen.de.ibm.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>
Date: Mon, 16 Jul 2007 12:53:52 +0200

> Subject: [PATCH] netfilter: xt_connlimit needs to depend on nf_conntrack
> From: Cornelia Huck <cornelia.huck@de.ibm.com>
> To: <linux-netdev@vger.kernel.org>
> Cc: <linux-kernel@vger.kernel.org>, netfilter-devel@lists.netfilter.org,
>         "David S. Miller" <davem@davemloft.net>,
>         Jan Engelhardt <jengelh@linux01.gwdg.de>,
>         Patrick McHardy <kaber@trash.net>
> Date: Mon, 16 Jul 2007 12:53:52 +0200
> X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
> Organization: IBM Deutschland Entwicklung GmbH
> 
> With NF_CONNTRACK=n, NETFILTER_XT_MATCH_CONNLIMIT=m I get the
> following errors on current git:
> 
>   CC [M]  net/netfilter/xt_connlimit.o
>   In file included from net/netfilter/xt_connlimit.c:27:
>   include/net/netfilter/nf_conntrack.h:100: error: field 'ct_general' has incomplete type
>   include/net/netfilter/nf_conntrack.h: In function 'nf_ct_get':
>   include/net/netfilter/nf_conntrack.h:164: error: 'const struct sk_buff' has no member named 'nfct'
>   include/net/netfilter/nf_conntrack.h: In function 'nf_ct_put':
>   include/net/netfilter/nf_conntrack.h:171: warning: implicit declaration of function 'nf_conntrack_put'
>   include/net/netfilter/nf_conntrack.h: In function 'nf_ct_is_untracked':
>   include/net/netfilter/nf_conntrack.h:253: error: 'const struct sk_buff' has no member named 'nfct'
>   In file included from net/netfilter/xt_connlimit.c:28:
>   include/net/netfilter/nf_conntrack_core.h: In function 'nf_conntrack_confirm':
>   include/net/netfilter/nf_conntrack_core.h:68: error: 'struct sk_buff' has no member named 'nfct'
> 
> Adding a dependency in Kconfig fixes this.
> 
> Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

Applied, thanks.
