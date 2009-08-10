Return-Path: <linux-kernel-owner+w=401wt.eu-S1752921AbZHJSo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbZHJSo3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 14:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbZHJSo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 14:44:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53179 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbZHJSo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 14:44:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] macvlan: add tap device backend
Date: Mon, 10 Aug 2009 20:43:32 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.2.98; x86_64; ; )
Cc: netdev@vger.kernel.org,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "" <davem@davemloft.net>, "Michael S. Tsirkin" <mst@redhat.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Or Gerlitz <ogerlitz@voltaire.com>,
       "Fischer, Anna" <anna.fischer@hp.com>,
       bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Edge Virtual Bridging <evb@yahoogroups.com>
References: <1249595428-21594-1-git-send-email-arnd@arndb.de> <4A7FC27F.1090904@trash.net>
In-Reply-To: <4A7FC27F.1090904@trash.net>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200908102043.32937.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19qATjtvk2hQk23HBd7emEYpkzXlZKrib1D9t5
 6nNAaFstlYU92uIKIqk5WimDDctaRjLF7fbnmCYptTAZsHJM9K
 dFrFUXDdHTXbJ0aJZ/GAQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 August 2009, Patrick McHardy wrote:

> macvlan will remove all macvlan/vtap devices when the underlying
> device in unregistered, at which time you need to release the
> device references you're holding. I'd suggest to change the
> macvlan_device_event() handler to use
> 
> vlan->dev->rtnl_link_ops->dellink(vlan->dev)
> 
> instead of macvlan_dellink() so the macvtap_dellink callback
> is invoked.

Ok, will do that. Thanks,

	Arnd <><

