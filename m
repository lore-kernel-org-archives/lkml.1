Return-Path: <linux-kernel-owner+w=401wt.eu-S1755962AbYLELyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbYLELyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 06:54:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750895AbYLELyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 06:54:00 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54934 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750773AbYLELx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 06:53:59 -0500
Date: Fri, 5 Dec 2008 11:52:25 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
       Alasdair G Kergon <agk@redhat.com>,
       Andi Kleen <andi-suse@firstfloor.org>, Milan Broz <mbroz@redhat.com>
Subject: Re: Device loses barrier support (was: Fixed patch for simple
 barriers.)
Message-ID: <20081205115225.13c277ee@lxorguk.ukuu.org.uk>
In-Reply-To: <20081205013739.GZ6703@one.firstfloor.org>
References: <20081204142015.GQ6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812040913510.6118@hs20-bc2-1.build.redhat.com>
	<20081204145810.GR6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812041139200.2434@hs20-bc2-1.build.redhat.com>
	<20081204174838.GS6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812041401210.23079@hs20-bc2-1.build.redhat.com>
	<20081204221551.GV6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812041756550.29638@hs20-bc2-1.build.redhat.com>
	<20081205004849.GX6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812041948400.14114@hs20-bc2-1.build.redhat.com>
	<20081205013739.GZ6703@one.firstfloor.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Dec 2008 02:37:39 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> > * barrier support in md-raid1 deviates from the specification at 
> > Documentation/block/barrier.txt. The specification says that requests 
> > submitted after the barrier request hit the media after the barrier 
> > request hits the media. The reality is that the barrier request can be 
> > randomly aborted and the requests submitted after it hit the media before 
> > the barrier request.
> 
> Yes the spec should be probably updated.
> 
> But also see Linus' rant from yesterday about code vs documentation.
> When in doubt the code wins.

Not when the fundamental design of the code is broken and trashes
performance. The documented behaviour is strongly desirable.

Alan
