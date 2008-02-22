Return-Path: <linux-kernel-owner+w=401wt.eu-S1762064AbYBVUds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762064AbYBVUds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 15:33:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754013AbYBVUdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 15:33:39 -0500
Received: from smtp5.freeserve.com ([193.252.22.159]:45399 "EHLO
	smtp5.freeserve.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbYBVUdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 15:33:37 -0500
X-ME-UUID: 20080222203331403.628371C0008A@mwinf3413.me.freeserve.com
Subject: Re: [Rt2400-devel] 2.6.25-rc2 regression in rt61pci wireless driver
From: Chris Vine <chris@cvine.freeserve.co.uk>
To: chris2553@googlemail.com
Cc: Dan Williams <dcbw@redhat.com>, Ivo van Doorn <ivdoorn@gmail.com>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       rt2400-devel@lists.sourceforge.net
In-Reply-To: <200802220739.15366.chris2553@googlemail.com>
References: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com>
	 <200802212304.28731.chris2553@googlemail.com>
	 <1203636027.3186.5.camel@boulder.homenet>
	 <200802220739.15366.chris2553@googlemail.com>
Content-Type: text/plain
Date: Fri, 22 Feb 2008 20:33:18 +0000
Message-Id: <1203712398.3709.6.camel@boulder.homenet>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-22 at 07:39 +0000, Chris Clayton wrote:
> On Thursday 21 February 2008, Chris Vine wrote:
[snip]
> > 
> > Does the same happen with 2.0.14 under kernel 2.6.24?
> 
> Unfortunately, a 2.6.24.2 tree with the drivers/net/wireless/rt2x00 directory replaced with that from 2.6.25-rc2-git4 doesn't build:

You have to have a version of mac80211 which is current with the version
of rt2x00 2.0.14.  If you don't want to go back into wireless-2.6 git to
do that I can send you my known working copy (for rt73 and I hope for
rt61) of compat-wireless-2.6 which will compile under 2.6.24.  However
it is just over 1MB in size so I won't sent it to you unless you would
like me to do that instead of you pulling git from wireless-2.6 for mid
January (actually the most recent working version would be immediately
before the patch which raised the version of rt2x00 to 2.1.0).

Chris


