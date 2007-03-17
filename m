Return-Path: <linux-kernel-owner+w=401wt.eu-S1751783AbXCQWNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbXCQWNr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 18:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbXCQWNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 18:13:47 -0400
Received: from p02c11o143.mxlogic.net ([208.65.144.76]:41432 "EHLO
	p02c11o143.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbXCQWNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 18:13:46 -0400
X-Greylist: delayed 1926 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Mar 2007 18:13:46 EDT
Date: Sat, 17 Mar 2007 23:41:36 +0200
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [2/6] 2.6.21-rc2: known regressions
Message-ID: <20070317214136.GE4466@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015034.GG3441@stusta.de> <20070308123143.GF5149@mellanox.co.il> <Pine.LNX.4.64.0703080954220.10832@woody.linux-foundation.org> <20070308195735.GG17114@mellanox.co.il> <20070311120802.GA8823@elte.hu> <20070312201820.GA8995@mellanox.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070312201820.GA8995@mellanox.co.il>
User-Agent: Mutt/1.5.11
X-OriginalArrivalTime: 17 Mar 2007 21:44:44.0836 (UTC) FILETIME=[7A113E40:01C768DD]
X-TM-AS-Product-Ver: SMEX-7.0.0.1526-3.6.1039-15058.001
X-TM-AS-Result: No--13.091200-4.000000-4
X-Spam: [F=0.0100000000; S=0.010(2007030701)]
X-MAIL-FROM: <mst@dev.mellanox.co.il>
X-SOURCE-IP: [194.90.237.34]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Michael S. Tsirkin <mst@dev.mellanox.co.il>:
> Subject: Re: [2/6] 2.6.21-rc2: known regressions
> 
> > Quoting Ingo Molnar <mingo@elte.hu>:
> > Subject: Re: [2/6] 2.6.21-rc2: known regressions
> > 
> > 
> > Michael,
> > 
> > * Michael S. Tsirkin <mst@mellanox.co.il> wrote:
> > 
> > > > > 2. First disk access after resume takes a couple of minutes
> > > > >    (seemed instant with 2.6.20) during this time no new messages show on console
> > > > 
> > > > Yeah, there is some problem with SATA resume. It would be beautiful if the 
> > > > people who actually see this could narrow it down with bisection. "It 
> > > > works for me" is clearly the case for many people, but not all.
> > > 
> > > Problem is, there seem to be multiple problems some of which got fixed 
> > > between rc2 and rc3. With rc2 I didn't get as far as getting to 
> > > console.
> > 
> > a quick ping: on your box that doesnt resume - if you can log in over 
> > the network after resume (or somehow run shell commands), does 'date' 
> > advance properly or not? (or do you not get that far to be able to 
> > tell?)
> > 
> > 	Ingo
> 
> I just retested - 'date' does not advance after resume for me.
> This is with NO_HZ *not* set.
> Sorry it took so long.

Update: just re-tested with 2.6.21-rc4, same behaviour: date
does not advance after resume from ram.

-- 
MST
