Return-Path: <linux-kernel-owner+w=401wt.eu-S1753399AbXL2Bmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbXL2Bmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 20:42:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755584AbXL2Bm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 20:42:28 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:59634 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573AbXL2Bm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 20:42:27 -0500
Subject: Re: [PATCH 01/12] Use mutex instead of semaphore in driver core
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <a8e1da0712281736p6dcc3f05vdb3b8ed9618e0147@mail.gmail.com>
References: <20071229010157.GB2883@darkstar.te-china.tietoenator.com>
	 <1198891742.6821.98.camel@twins>
	 <a8e1da0712281736p6dcc3f05vdb3b8ed9618e0147@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 29 Dec 2007 02:42:24 +0100
Message-Id: <1198892544.6821.103.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-12-29 at 09:36 +0800, Dave Young wrote:
> On Dec 29, 2007 9:29 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> >
> > I'm pretty sure you didn't boot that kernel with lockdep enabled.
> Yes, I will try rebuild with lockdep  and test.

I'll fail miserably :-)

>From your other mail:
> No,  I checked the config , lockdep is indeed enabled. But I will try
> to test with the lock debug options enabled in a while.

You need to actually boot the kernel to get effective reports from
lockdep, it'll build just fine.

> > Also, most, if not all, of your patches miss a patch description.
> 
> Does the description really needed for it? IMHO, the subject is enough
> to descript the patches.

Preferably, the subject might convey what you are doing, but the full
description should at least add to that by telling _why_ you are doing
that.

Also, I don't think your series is bisectable, ie. 1/12 changes
device::sem -> device::mutex, and 12/12 changes a user of it.

