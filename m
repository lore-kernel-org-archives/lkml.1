Return-Path: <linux-kernel-owner+w=401wt.eu-S1756082AbXIBEn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082AbXIBEn3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 00:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750972AbXIBEnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 00:43:19 -0400
Received: from phunq.net ([64.81.85.152]:60818 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750749AbXIBEnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 00:43:17 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [1/1] Block device throttling [Re: Distributed storage.]
Date: Sat, 1 Sep 2007 21:42:53 -0700
User-Agent: KMail/1.9.5
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Jens Axboe <jens.axboe@oracle.com>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Neil Brown <neilb@suse.de>
References: <20070731171347.GA14267@2ka.mipt.ru> <200708301620.37965.phillips@phunq.net> <20070831214137.GD30122@agk.fab.redhat.com>
In-Reply-To: <20070831214137.GD30122@agk.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709012142.55534.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 August 2007 14:41, Alasdair G Kergon wrote:
> On Thu, Aug 30, 2007 at 04:20:35PM -0700, Daniel Phillips wrote:
> > Resubmitting a bio or submitting a dependent bio from
> > inside a block driver does not need to be throttled because all
> > resources required to guarantee completion must have been obtained
> > _before_ the bio was allowed to proceed into the block layer.
>
> I'm toying with the idea of keeping track of the maximum device stack
> depth for each stacked device, and only permitting it to increase in
> controlled circumstances.

Hi Alasdair,

What kind of circumstances did you have in mind?

Regards,

Daniel
