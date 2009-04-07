Return-Path: <linux-kernel-owner+w=401wt.eu-S1754235AbZDGK3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbZDGK3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 06:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbZDGK3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 06:29:31 -0400
Received: from mail.gmx.net ([213.165.64.20]:34984 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751716AbZDGK3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 06:29:30 -0400
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Tulio Magno Quites Machado Filho <tuliom@quites.com.br>
Content-Type: text/plain; charset="us-ascii"
Date: Tue, 07 Apr 2009 12:29:27 +0200
From: =?iso-8859-1?Q?=22Markus_Ko=DFmann=22?= <mkossmann_ml1@gmx.de>
In-Reply-To: <1239097961.32048.484.camel@localhost>
Message-ID: <20090407102927.225890@gmx.net>
MIME-Version: 1.0
References: <1239008128.32048.211.camel@localhost>	
 <20090406195544.GA3542@joutaro.rooms.iriga>
 <1239097961.32048.484.camel@localhost>
Subject: Re: 2.6.29+ ath5k connect disconnect cycles?
To: Soeren Sonnenburg <sonne@debian.org>
X-Authenticated: #36390367
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1/9QHx90rf9VALPbAu78DPgnITU9WaitjSFd6qhrQ
 vQhfHrtOVls1p4DwFXKySGdy2wd5ZOChSzzg== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: PhPtAHUfQEV/FOhzQndpfi9CNzg2NYJS
X-FuHaFi: 0.59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Mon, 2009-04-06 at 21:55 +0200, Tulio Magno Quites Machado Filho
> wrote:
> > On Apr 06 09 10:55, Soeren Sonnenburg wrote:
> > > does anyone else observer strange connect disconnect cycles with
> ath5k?
> > > I have two different notebooks here one with an AR5414 and one with
> some
> > > 2424 (?) chipset both having the same problems to connect...
> > 
> > Hello Soeren,
> > 
> > Is there any information from dmesg?
> 
> I am seeing cycles of
> 
> airport: deauthenticated (Reason: 2)
> airport: direct probe to AP XX:XX:XX:XX:XX:XX try 1
> airport direct probe responded
> airport: authenticate with AP XX:XX:XX:XX:XX:XX
> airport: authenticated
> airport: associate with AP XX:XX:XX:XX:XX:XX
> airport: RX ReassocResp from XX:XX:XX:XX:XX:XX (capab=0x421 status=0
> aid=79)
> airport: associated
> airport: deauthenticated (Reason: 2)
> airport: direct probe to AP XX:XX:XX:XX:XX:XX try 1
> airport direct probe responded
> airport: authenticate with AP XX:XX:XX:XX:XX:XX
> airport: authenticated
> airport: associate with AP XX:XX:XX:XX:XX:XX
> airport: RX ReassocResp from XX:XX:XX:XX:XX:XX (capab=0x421 status=0
> aid=81)
> airport: associated
> airport: deauthenticated (Reason: 2)
> airport: direct probe to AP XX:XX:XX:XX:XX:XX try 1
> airport direct probe responded
> airport: authenticate with AP XX:XX:XX:XX:XX:XX
> airport: authenticated
> airport: associate with AP XX:XX:XX:XX:XX:XX
> airport: RX ReassocResp from XX:XX:XX:XX:XX:XX (capab=0x421 status=0
> aid=82)
> airport: associated
> airport: deauthenticated (Reason: 2)
> ...
> 
> Not sure about the involvement of network-manager here... but I see that
> the device gets a valid IP via dhcp.
> 
I've seen such cycles also with intel ipw5300 WLAN and using ifconfig to start the network. To get WLAN working again, I have to ifdown wlan0 , unload and reload the driver module and  finally ifup wlan0. So it's probably neither a ath5k nor a network-manager problem.
