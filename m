Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199AbZKSOrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbZKSOrI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 09:47:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755158AbZKSOrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 09:47:07 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:51859 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbZKSOrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 09:47:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/3] macvlan: export macvlan mode through netlink
Date: Thu, 19 Nov 2009 15:47:03 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Patrick Mullaney <pmullaney@novell.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Edge Virtual Bridging <evb@yahoogroups.com>,
       Anna Fischer <anna.fischer@hp.com>, bridge@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       Jens Osterkamp <jens@linux.vnet.ibm.com>,
       Gerhard Stenzel <gerhard.stenzel@de.ibm.com>
References: <1258497551-25959-1-git-send-email-arnd@arndb.de> <200911181059.45331.arnd@arndb.de> <4B05586C.5020308@trash.net>
In-Reply-To: <4B05586C.5020308@trash.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200911191547.03509.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19ZgIY4rnc5EBxnDN+uzC85pSMj8iZ/oEcV2aJ
 kshJjlRv+G93flGB86QBRm2XbuZrWl8C/XlGbzjqMssDhUXWn+
 oF/hidH+z8SgFr4B5JATg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 November 2009, Patrick McHardy wrote:
> > +enum ifla_macvlan_mode {
> > +     MACVLAN_MODE_PRIVATE = 1, /* don't talk to other macvlans */
> > +     MACVLAN_MODE_VEPA    = 2, /* talk to other ports through ext bridge */
> > +     MACVLAN_MODE_BRIDGE  = 4, /* talk to bridge ports directly */
> > +};
> 
> Please also keep the enum named something without ifla_ since
> the mode values themselves are not netlink attributes. Just
> macvlan_mode seems fine.

Ok, good. I was unsure on the naming and also changed between MACVLAN_*
and MACVLAN_MODE_* a few times.

Thanks for the clarification,

	Arnd <><
