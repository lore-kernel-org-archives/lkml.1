Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbZKRJ7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbZKRJ7w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 04:59:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756671AbZKRJ7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 04:59:51 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:53621 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867AbZKRJ7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 04:59:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 3/3] macvlan: export macvlan mode through netlink
Date: Wed, 18 Nov 2009 10:59:45 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Patrick McHardy <kaber@trash.net>,
       Patrick Mullaney <pmullaney@novell.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Edge Virtual Bridging <evb@yahoogroups.com>,
       Anna Fischer <anna.fischer@hp.com>, bridge@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       Jens Osterkamp <jens@linux.vnet.ibm.com>,
       Gerhard Stenzel <gerhard.stenzel@de.ibm.com>
References: <1258497551-25959-1-git-send-email-arnd@arndb.de> <1258497551-25959-4-git-send-email-arnd@arndb.de> <4B0398D4.8030904@gmail.com>
In-Reply-To: <4B0398D4.8030904@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911181059.45331.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19nH8f9c6uiXYk8tkAG2EPe9VPdW/dL9zIL4AB
 CPr2ueeRVJVLeQqi6DCld8GkCDgyRm26CTUpZXk8gk4MQZJrv1
 8gVEtmTHuKdvR2PGKdWvw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 November 2009, Eric Dumazet wrote:
> > --- a/drivers/net/macvlan.c
> > +++ b/drivers/net/macvlan.c
> > @@ -33,12 +33,6 @@
> >  
> >  #define MACVLAN_HASH_SIZE    (1 << BITS_PER_BYTE)
> >  
> > -enum macvlan_type {
> > -     MACVLAN_PRIVATE         = 1,
> > -     MACVLAN_VEPA            = 2,
> > -     MACVLAN_BRIDGE          = 4,
> > -};
> 
> I realize you defined MACVLAN_PRIVATE in patch 2, but used MACVLAN_MODE_PRIVATE,
> so patch 2 is not compilable and breaks bisection ?
> 

Hmm, right. I'll fix that up as well.

Thanks,

	Arnd <><
