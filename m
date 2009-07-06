Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbZGFRY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbZGFRY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 13:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbZGFRYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 13:24:48 -0400
Received: from mail.anarazel.de ([217.115.131.40]:56000 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843AbZGFRYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 13:24:48 -0400
From: Andres Freund <andres@anarazel.de>
To: Jarek Poplawski <jarkao2@gmail.com>
Subject: Re: Soft-Lockup/Race in networking in 2.6.31-rc1+195 ( possibly?caused by netem)
Date: Mon, 6 Jul 2009 19:24:47 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc1-andres-00457-g396ca83-dirty; KDE/4.2.95; x86_64; ; )
Cc: Joao Correia <joaomiguelcorreia@gmail.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Stephen Hemminger <shemminger@vyatta.com>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <200907031326.21822.andres@anarazel.de> <200907061813.29379.andres@anarazel.de> <20090706163106.GA4559@ami.dom.local>
In-Reply-To: <20090706163106.GA4559@ami.dom.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907061924.48448.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 July 2009 18:31:06 Jarek Poplawski wrote:
> On Mon, Jul 06, 2009 at 06:13:29PM +0200, Andres Freund wrote:
> > > > Btw, I ran netem with delay for more than 48h on around 80mbit...
> > > > That does  not exclude such a rarely triggered race, but makes it a
> > > > bit more unlikely. (With migration thats around 3sec or so)
> > Sorry once more.
> Andres, the bisection + the above - you did 'the whole lotta work' and
> you shouldn't be sorry at all! ;-)
To be fair I have to admit I did run netem for 48hours for other reasons ;-)
I also ran my modified netem, but all it currently does is adjusing 
delay/jitter by other means, so that should have no influence.
I am trying to produce artificial loss patterns similar to really occuring 
network loss.

I just switched mail client btw ;-)

ATM I have no further ideas except maybe trying different timers or a lower 
timer resolution?

Andres
