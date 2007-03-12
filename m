Return-Path: <linux-kernel-owner+w=401wt.eu-S1752862AbXCLUTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbXCLUTb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 16:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbXCLUTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 16:19:31 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:2828 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbXCLUTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 16:19:30 -0400
Date: Mon, 12 Mar 2007 22:20:05 +0200
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [2/6] 2.6.21-rc2: known regressions
Message-ID: <20070312201820.GA8995@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
	<20070305015034.GG3441@stusta.de>
	<20070308123143.GF5149@mellanox.co.il>
	<Pine.LNX.4.64.0703080954220.10832@woody.linux-foundation.org>
	<20070308195735.GG17114@mellanox.co.il>
	<20070311120802.GA8823@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070311120802.GA8823@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Ingo Molnar <mingo@elte.hu>:
> Subject: Re: [2/6] 2.6.21-rc2: known regressions
> 
> 
> Michael,
> 
> * Michael S. Tsirkin <mst@mellanox.co.il> wrote:
> 
> > > > 2. First disk access after resume takes a couple of minutes
> > > >    (seemed instant with 2.6.20) during this time no new messages show on console
> > > 
> > > Yeah, there is some problem with SATA resume. It would be beautiful if the 
> > > people who actually see this could narrow it down with bisection. "It 
> > > works for me" is clearly the case for many people, but not all.
> > 
> > Problem is, there seem to be multiple problems some of which got fixed 
> > between rc2 and rc3. With rc2 I didn't get as far as getting to 
> > console.
> 
> a quick ping: on your box that doesnt resume - if you can log in over 
> the network after resume (or somehow run shell commands), does 'date' 
> advance properly or not? (or do you not get that far to be able to 
> tell?)
> 
> 	Ingo

I just retested - 'date' does not advance after resume for me.
This is with NO_HZ *not* set.
Sorry it took so long.

-- 
MST
