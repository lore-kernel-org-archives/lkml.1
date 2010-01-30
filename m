Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420Ab0A3W0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab0A3W0X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 17:26:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296Ab0A3W0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 17:26:21 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:65204 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078Ab0A3W0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 17:26:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: David Miller <davem@davemloft.net>
Subject: [PATCH 0/3 v4] macvtap driver
Date: Sat, 30 Jan 2010 23:22:15 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc5; KDE/4.3.2; x86_64; ; )
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Patrick McHardy <kaber@trash.net>,
       "Michael S. Tsirkin" <mst@redhat.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Or Gerlitz <ogerlitz@voltaire.com>, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org
References: <201001271104.20607.arnd@arndb.de>
In-Reply-To: <201001271104.20607.arnd@arndb.de>
MIME-Version: 1.0
Message-Id: <201001302322.15237.arnd@arndb.de>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19ib2qbEMTBWueLQyyCERm0nODdKCZakHTk6Ym
 zyLcw0GvNsv20oqMdkJ4Jnx/TKL2y9az2tOyb0VcypPbsVjYU6
 /TT3binOYVaII3tQr88bg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the fourth version of the macvtap driver,
based on the comments I got for the last version
I got a few days ago. Very few changes:

* release netdev in chardev open function so
  we can destroy it properly.
* Implement TUNSETSNDBUF
* fix sleeping call in rcu_read_lock
* Fix comment in namespace isolation patch
* Fix small context difference to make it apply
  to net-next

I can't really test here while travelling, so please
give it a go if you're interested in this driver.

	Arnd

