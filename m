Return-Path: <linux-kernel-owner+w=401wt.eu-S1761098AbZGIQqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761098AbZGIQqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 12:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760154AbZGIQqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 12:46:42 -0400
Received: from mail.anarazel.de ([217.115.131.40]:43829 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759419AbZGIQqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 12:46:42 -0400
From: Andres Freund <andres@anarazel.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Soft-Lockup/Race in networking in 2.6.31-rc1+195 ( possibly?caused by netem)
Date: Thu, 9 Jul 2009 18:46:37 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc2-andres-00152-g6a6dd01-dirty; KDE/4.2.95; x86_64; ; )
Cc: Jarek Poplawski <jarkao2@gmail.com>,
       Joao Correia <joaomiguelcorreia@gmail.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Stephen Hemminger <shemminger@vyatta.com>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Patrick McHardy <kaber@trash.net>,
       Peter Zijlstra <peterz@infradead.org>
References: <200907031326.21822.andres@anarazel.de> <200907091728.23367.andres@anarazel.de> <alpine.LFD.2.00.0907091801130.24704@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0907091801130.24704@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907091846.37926.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 July 2009 18:01:56 Thomas Gleixner wrote:
> Andres,
>
> On Thu, 9 Jul 2009, Andres Freund wrote:
> > On Thursday 09 July 2009 16:28:05 Thomas Gleixner wrote:
> > > Please test them separate from each other. The one I sent in this
> > > thread was just for narrowing down the issue, but I'm now quite sure
> > > that they really hit the issue which is addressed by the hrtimer
> > > patch.
> >
> > No crash yet. 15min running (seconds to a minute before).
> >
> > Will let it run for some hours to be sure.
>
> Which one of the patches are you testing ?
Your "real" one, i.e. de907e8432b08f2d5966c36e0747e97c0e596810

1h30m now...


Andres
