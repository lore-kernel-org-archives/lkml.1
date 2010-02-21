Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab0BUWSd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 17:18:33 -0500
Received: from alternativer.internetendpunkt.de ([88.198.24.89]:41421 "EHLO
	geheimer.internetendpunkt.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753180Ab0BUWSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 17:18:32 -0500
Date: Sun, 21 Feb 2010 23:18:29 +0100
From: Hagen Paul Pfeifer <hagen@jauu.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andreas Petlund <apetlund@simula.no>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Ilpo J?rvinen <ilpo.jarvinen@helsinki.fi>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
       LKML <linux-kernel@vger.kernel.org>, shemminger@vyatta.com,
       David Miller <davem@davemloft.net>, william.allen.simpson@gmail.com,
       damian@tvk.rwth-aachen.de, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [net-next PATCH v4 1/3] net: TCP thin-stream detection
Message-ID: <20100221221829.GX2659@nuttenaction>
References: <4B7AAE60.3070305@simula.no>
 <20100221102102.GB1311@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100221102102.GB1311@ucw.cz>
X-Key-Id: 98350C22
X-Key-Fingerprint: 490F 557B 6C48 6D7E 5706 2EA2 4A22 8D45 9835 0C22
X-GPG-Key: gpg --recv-keys --keyserver wwwkeys.eu.pgp.net 98350C22
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek | 2010-02-21 11:21:03 [+0100]:

>> +1) If the stream is thin, fast retransmit on the first dupACK.
>> +2) If the stream is thin, do not apply exponential backoff.
>
>2) seems very dangerous/unfair. If network  congestion is caused just
>by thin streams, will the network just fall apart?

I question the fairness of this modification! The modification sounds _really_
far-reaching. Did you analyse the behaviour of this modification? What about
fairness analysis? Great work is available in the network simulator sector for
this kind of analysis (e.g. jain's fairness index).


HGN

-- 
Hagen Paul Pfeifer <hagen@jauu.net>  ||  http://jauu.net/
Telephone: +49 174 5455209           ||  Key Id: 0x98350C22
Key Fingerprint: 490F 557B 6C48 6D7E 5706 2EA2 4A22 8D45 9835 0C22
