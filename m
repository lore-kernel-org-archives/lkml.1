Return-Path: <linux-kernel-owner+w=401wt.eu-S932887AbZKXNPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887AbZKXNPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 08:15:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932700AbZKXNPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 08:15:14 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:57634 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932541AbZKXNPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 08:15:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/4] veth: move loopback logic to common location
Date: Tue, 24 Nov 2009 14:13:09 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: virtualization@lists.linux-foundation.org,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Anna Fischer <anna.fischer@hp.com>, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Mark Smith <lk-netdev@lk-netdev.nosense.org>,
       Gerhard Stenzel <gerhard.stenzel@de.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jens Osterkamp <jens@linux.vnet.ibm.com>,
       Patrick Mullaney <pmullaney@novell.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Edge Virtual Bridging <evb@yahoogroups.com>,
       David Miller <davem@davemloft.net>
References: <1259024166-28158-1-git-send-email-arnd@arndb.de> <200911241034.43961.arnd@arndb.de> <4B0BB818.6090509@trash.net>
In-Reply-To: <4B0BB818.6090509@trash.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200911241413.09214.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+brFJa3cGm1ymO8/7z6SmbWbQkvkM5CxxTe8i
 Nga4Ph7Nbnoc9my/65UW49LZjp7gFdlGIF0G42LuC+NuqvDTEt
 6j0PZEJFJf31S2Wey0wDg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 November 2009, Patrick McHardy wrote:
> I don't think its necessary, we bypass outgoing queuing anyways.
> But if you'd want to add it, just keeping the skb->mark clearing
> in veth should work from what I can tell.

Ok, I won't bother with it for now then.

	Arnd <><
