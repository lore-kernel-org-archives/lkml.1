Return-Path: <linux-kernel-owner+w=401wt.eu-S933952AbXGQPHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933952AbXGQPHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 11:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbXGQPHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 11:07:19 -0400
Received: from stinky.trash.net ([213.144.137.162]:46618 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbXGQPHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 11:07:18 -0400
Message-ID: <469CDB20.8090806@trash.net>
Date: Tue, 17 Jul 2007 17:07:12 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: linux-netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       netfilter-devel@lists.netfilter.org,
       "David S. Miller" <davem@davemloft.net>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH] netfilter: xt_connlimit needs to depend on nf_conntrack
References: <20070716125352.3525ec5b@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070716125352.3525ec5b@gondolin.boeblingen.de.ibm.com>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck wrote:
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
