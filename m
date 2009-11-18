Return-Path: <linux-kernel-owner+w=401wt.eu-S1756934AbZKRJtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934AbZKRJtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 04:49:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754978AbZKRJta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 04:49:30 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:62362 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbZKRJt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 04:49:29 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 2/3] macvlan: implement VEPA and private mode
Date: Wed, 18 Nov 2009 10:48:04 +0100
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
       virtualization@lists.linux-foundation.com,
       Jens Osterkamp <jens@linux.vnet.ibm.com>,
       Gerhard Stenzel <gerhard.stenzel@de.ibm.com>
References: <1258497551-25959-1-git-send-email-arnd@arndb.de> <1258497551-25959-3-git-send-email-arnd@arndb.de> <4B03974D.3010708@gmail.com>
In-Reply-To: <4B03974D.3010708@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911181048.04233.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19IuvXI6Y0OvoUz25iuAtUP+rAs4NETdDRBssN
 7fLxZAG5l/m6rEunV7Jj7jPtzle5D0R9SXTVHo/yvnQU5ud0wq
 8bLW5GgR+z1vU41OSt2yQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 November 2009, Eric Dumazet wrote:
> > +                     macvlan_broadcast(skb, port, NULL, MACVLAN_MODE_VEPA
> > +                             | MACVLAN_MODE_VEPA | MACVLAN_MODE_BRIDGE);
> 
> typo here, you probably meant MACVLAN_PRIVATE | MACVLAN_VEPA | MACVLAN_BRIDGE 

Well spotted. One last minute-change gone wrong.

Thanks,

	Arnd <><
