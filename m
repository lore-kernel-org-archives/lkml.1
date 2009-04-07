Return-Path: <linux-kernel-owner+w=401wt.eu-S1752809AbZDGJw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbZDGJw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 05:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbZDGJwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 05:52:47 -0400
Received: from nn7.de ([85.214.94.156]:53843 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbZDGJwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 05:52:46 -0400
Subject: Re: 2.6.29+ ath5k connect disconnect cycles?
From: Soeren Sonnenburg <sonne@debian.org>
To: Tulio Magno Quites Machado Filho <tuliom@quites.com.br>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       ath5k-devel <ath5k-devel@venema.h4ckr.net>
In-Reply-To: <20090406195544.GA3542@joutaro.rooms.iriga>
References: <1239008128.32048.211.camel@localhost>
	 <20090406195544.GA3542@joutaro.rooms.iriga>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 07 Apr 2009 11:52:41 +0200
Message-Id: <1239097961.32048.484.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-06 at 21:55 +0200, Tulio Magno Quites Machado Filho
wrote:
> On Apr 06 09 10:55, Soeren Sonnenburg wrote:
> > does anyone else observer strange connect disconnect cycles with ath5k?
> > I have two different notebooks here one with an AR5414 and one with some
> > 2424 (?) chipset both having the same problems to connect...
> 
> Hello Soeren,
> 
> Is there any information from dmesg?

I am seeing cycles of

airport: deauthenticated (Reason: 2)
airport: direct probe to AP XX:XX:XX:XX:XX:XX try 1
airport direct probe responded
airport: authenticate with AP XX:XX:XX:XX:XX:XX
airport: authenticated
airport: associate with AP XX:XX:XX:XX:XX:XX
airport: RX ReassocResp from XX:XX:XX:XX:XX:XX (capab=0x421 status=0 aid=79)
airport: associated
airport: deauthenticated (Reason: 2)
airport: direct probe to AP XX:XX:XX:XX:XX:XX try 1
airport direct probe responded
airport: authenticate with AP XX:XX:XX:XX:XX:XX
airport: authenticated
airport: associate with AP XX:XX:XX:XX:XX:XX
airport: RX ReassocResp from XX:XX:XX:XX:XX:XX (capab=0x421 status=0 aid=81)
airport: associated
airport: deauthenticated (Reason: 2)
airport: direct probe to AP XX:XX:XX:XX:XX:XX try 1
airport direct probe responded
airport: authenticate with AP XX:XX:XX:XX:XX:XX
airport: authenticated
airport: associate with AP XX:XX:XX:XX:XX:XX
airport: RX ReassocResp from XX:XX:XX:XX:XX:XX (capab=0x421 status=0 aid=82)
airport: associated
airport: deauthenticated (Reason: 2)
...

Not sure about the involvement of network-manager here... but I see that
the device gets a valid IP via dhcp.

Soeren
-- 
For the one fact about the future of which we can be certain is that it
will be utterly fantastic. -- Arthur C. Clarke, 1962
