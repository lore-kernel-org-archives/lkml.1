Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbXKBOR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbXKBOR0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 10:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753770AbXKBORS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 10:17:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41700 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688AbXKBORR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 10:17:17 -0400
Subject: Re: per BDI dirty limit (was Re: -mm merge plans for 2.6.24)
From: Peter Zijlstra <peterz@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Fengguang Wu <fengguang.wu@gmail.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Miklos Szeredi <miklos@szeredi.hu>
In-Reply-To: <3ae72650711020650l37870e45yb853f888b4807116@mail.gmail.com>
References: <1193410087.6914.34.camel@twins>
	 <1193412836.27652.11.camel@twins> <1193414147.2431.35.camel@lov.site>
	 <1193429066.5648.35.camel@lappy> <1193447889.5648.44.camel@lappy>
	 <20071027024033.GB29039@kroah.com> <1193474399.27652.15.camel@twins>
	 <20071027160203.GA5709@kroah.com> <1193519317.5776.14.camel@lov.site>
	 <1194009359.27652.377.camel@twins>
	 <3ae72650711020650l37870e45yb853f888b4807116@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 02 Nov 2007 15:17:08 +0100
Message-Id: <1194013028.27652.387.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

One more question,

I currently prefix the names with "bdi-", is that needed?

That is, if I give the bdi object a parent, how will it look?
Would a bdi device with name "sda" with a block device called "sda" as
parent look like: /sys/block/sda/sda? Or would if be
called /sys/block/sda/bdi:sda or just /sys/block/sda/bdi?



