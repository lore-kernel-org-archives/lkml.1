Return-Path: <linux-kernel-owner+w=401wt.eu-S1758526AbZDACBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526AbZDACBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 22:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbZDACBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 22:01:22 -0400
Received: from sh.osrg.net ([192.16.179.4]:34449 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597AbZDACBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 22:01:22 -0400
Date: Wed, 1 Apr 2009 10:54:11 +0900
To: chrisw@sous-sol.org
Cc: torvalds@linux-foundation.org, James.Bottomley@HansenPartnership.com,
       linux-kernel@vger.kernel.org, stable@kernel.org, jmforbes@linuxtx.org,
       zwane@arm.linux.org.uk, tytso@mit.edu, rdunlap@xenotime.net,
       davej@redhat.com, chuckw@quantumlinux.com, reviews@ml.cw.f00f.org,
       mkrufky@linuxtv.org, cebbert@redhat.com, cavokz@gmail.com, w@1wt.eu,
       rbranco@la.checkpoint.com, jake@lwn.net, eteo@redhat.com,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       tonyb@cybernetics.com, fujita.tomonori@lab.ntt.co.jp,
       dgilbert@interlog.com
Subject: Re: [patch 25/45] SCSI: sg: fix races during device removal
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090401011533.GO18394@sequoia.sous-sol.org>
References: <1238544620.5000.5.camel@mulgrave.int.hansenpartnership.com>
	<alpine.LFD.2.00.0903311717330.4130@localhost.localdomain>
	<20090401011533.GO18394@sequoia.sous-sol.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090401105413U.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 01 Apr 2009 10:54:15 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009 18:15:33 -0700
Chris Wright <chrisw@sous-sol.org> wrote:

> * Linus Torvalds (torvalds@linux-foundation.org) wrote:
> > On Wed, 1 Apr 2009, James Bottomley wrote:
> > > 
> > > I think we could wait a bit to see if any issues turn up in 2.6.30
> > > testing.  I think it should go in eventually, though.
> > 
> > Sure, that sounds sane. But right now it has very little extra testing, so 
> > wait with putting it into -stable at _least_ until after -rc1 release or 
> > something?
> 
> I'll drop it (meaning the three).  James can you resend after they've
> withstood the test of time?

I really want to push the patches as soon as possible. The bug that
the 27/45 patch fixes has been for two months and I saw bug reports
about it again and again:

http://marc.info/?l=linux-kernel&m=123841463709919&w=2
