Return-Path: <linux-kernel-owner+w=401wt.eu-S1754805AbZHJNaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbZHJNaE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 09:30:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754752AbZHJNaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 09:30:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60870 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692AbZHJN37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 09:29:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] macvlan: add tap device backend
Date: Mon, 10 Aug 2009 15:29:46 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.2.98; x86_64; ; )
Cc: netdev@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Or Gerlitz <ogerlitz@voltaire.com>,
       "Fischer, Anna" <anna.fischer@hp.com>,
       bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Edge Virtual Bridging <evb@yahoogroups.com>
References: <1249595428-21594-1-git-send-email-arnd@arndb.de> <200908092042.24686.arnd@arndb.de> <20090810085003.GA3654@redhat.com>
In-Reply-To: <20090810085003.GA3654@redhat.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908101529.46285.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+0toNlNHHnKB8EENr0kRTBSrMC9h7u6qPfeUL
 NF3PuKJ/zNEqmInqhwthl6FmlrNFb4gM+/AuEJpEiqaCTkfOwH
 8yvybDNXVTNiVS72J6IyA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 August 2009, Michael S. Tsirkin wrote:
> 
> > Would it be enough to check the dev_queue_xmit() return
> > code for NETDEV_TX_BUSY?
> > 
> > How would I get notified when it gets free again?
> 
> You can do this by creating a socket. Look at how tun does
> this now.

Hmm, I was hoping to be able to avoid this, because I can
interact more directly with the outbound physical interface
using dev_queue_xmit() instead of netif_rx_ni().

I'll have a look. Thanks,

	Arnd <><
