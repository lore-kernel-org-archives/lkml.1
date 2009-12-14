Return-Path: <linux-kernel-owner+w=401wt.eu-S1757184AbZLNMJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184AbZLNMJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 07:09:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757167AbZLNMJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 07:09:50 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:59437 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757157AbZLNMJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 07:09:47 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] macvlan: add tap device backend
Date: Mon, 14 Dec 2009 13:00:36 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Patrick McHardy <kaber@trash.net>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       "Michael S. Tsirkin" <mst@redhat.com>,
       Or Gerlitz <ogerlitz@voltaire.com>,
       "Fischer, Anna" <anna.fischer@hp.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Edge Virtual Bridging <evb@yahoogroups.com>
References: <1259862720-28432-1-git-send-email-arnd@arndb.de> <1259862720-28432-3-git-send-email-arnd@arndb.de> <20091212084112.GA8948@gondor.apana.org.au>
In-Reply-To: <20091212084112.GA8948@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912141300.37063.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/QQMeaViuJ1kduIhYgosY6wUDJDoXtRwb5aof
 HNbcWVmPFqBUofap64JBcE5tP7HV8vmS0AvNSgdwZA0mwrfJjh
 /ZQjK8h+mGSaRYt1HI08w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 December 2009, Herbert Xu wrote:
> On Thu, Dec 03, 2009 at 06:52:00PM +0100, Arnd Bergmann wrote:
> > This is a second prototype of a new interface into the network
> > stack, to eventually replace tun/tap and the bridge driver
> > in certain virtual machine setups. The code has changed
> > significantly, but the goals still remain.
> 
> The idea looks pretty sound to me.

Thanks!

> > I'm posting this mainly to solicit feedback. Not sure how
> > chances for integration into 2.6.33 are, given that the merge
> > window is opening already.
> 
> It's way too late for 2.6.33.  But the earlier this becomes ready
> then the earlier it can go into linux-next.

Right. Since the code is basically working (I have two known bugs
I'm still working on) and people want to test it, what is the
best path? I could
a) keep my git tree for myself,
b) have it added to linux-next,
c) prepare a combined patch for net-next.git, or
d) have it added to drivers/staging

	Arnd

