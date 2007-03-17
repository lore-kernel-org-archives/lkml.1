Return-Path: <linux-kernel-owner+w=401wt.eu-S1752130AbXCQW0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbXCQW0v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 18:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbXCQW0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 18:26:51 -0400
Received: from www.osadl.org ([213.239.205.134]:50227 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752070AbXCQW0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 18:26:21 -0400
Subject: Re: [2/6] 2.6.21-rc2: known regressions
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070317214136.GE4466@mellanox.co.il>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
	 <20070305015034.GG3441@stusta.de> <20070308123143.GF5149@mellanox.co.il>
	 <Pine.LNX.4.64.0703080954220.10832@woody.linux-foundation.org>
	 <20070308195735.GG17114@mellanox.co.il> <20070311120802.GA8823@elte.hu>
	 <20070312201820.GA8995@mellanox.co.il>
	 <20070317214136.GE4466@mellanox.co.il>
Content-Type: text/plain
Date: Sat, 17 Mar 2007 23:33:16 +0100
Message-Id: <1174170796.13341.431.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-17 at 23:41 +0200, Michael S. Tsirkin wrote:
> > > a quick ping: on your box that doesnt resume - if you can log in over 
> > > the network after resume (or somehow run shell commands), does 'date' 
> > > advance properly or not? (or do you not get that far to be able to 
> > > tell?)
> > > 
> > > 	Ingo
> > 
> > I just retested - 'date' does not advance after resume for me.
> > This is with NO_HZ *not* set.
> > Sorry it took so long.
> 
> Update: just re-tested with 2.6.21-rc4, same behaviour: date
> does not advance after resume from ram.

Can you get a full dmesg from boot to resume out of the box ?

	tglx


