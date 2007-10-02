Return-Path: <linux-kernel-owner+w=401wt.eu-S1756842AbXJBLkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842AbXJBLkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 07:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbXJBLkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 07:40:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56597 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbXJBLkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 07:40:33 -0400
Subject: Re: per BDI dirty limit (was Re: -mm merge plans for 2.6.24)
From: Peter Zijlstra <peterz@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, greg@kroah.com
In-Reply-To: <3ae72650710020421t711caaa8o13d2e685a98e5fe8@mail.gmail.com>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
	 <1191313025.13204.30.camel@twins>
	 <20071002013148.18958af2.akpm@linux-foundation.org>
	 <1191314911.13204.41.camel@twins>
	 <3ae72650710020331o2ce5bd20wccc1964855279796@mail.gmail.com>
	 <1191321861.13204.53.camel@twins>
	 <3ae72650710020421t711caaa8o13d2e685a98e5fe8@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 02 Oct 2007 13:40:26 +0200
Message-Id: <1191325226.13204.63.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-02 at 13:21 +0200, Kay Sievers wrote:
> On 10/2/07, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, 2007-10-02 at 12:31 +0200, Kay Sievers wrote:
> >
> > > What would be the point in another top-level tree for device
> > > information? All devices you are exporting information for, are
> > > already in the sysfs tree, right?
> >
> > Never did find NFS mounts/servers/superblocks or whatever constitutes a
> > BDI for NFS in there. Same goes for all other networked filesystems for
> > that matter.
> 
> How about adding this information to the tree then, instead of
> creating a new top-level hack, just because something that you think
> you need doesn't exist.

So you suggest adding all the various network filesystems in there
(where?), and adding the concept of a BDI, and ensuring all are properly
linked together - somehow. Feel free to do so.

> You called sysfs a mess, seems you work on that topic too. :)

I called the in-kernel API to create sysfs files a mess. Not that I have
another opinion on the content of /sys though, always takes to damn long
to find anything in there.

