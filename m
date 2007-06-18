Return-Path: <linux-kernel-owner+w=401wt.eu-S1761610AbXFRA12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761610AbXFRA12 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 20:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756076AbXFRA1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 20:27:21 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:46708 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754943AbXFRA1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 20:27:20 -0400
Date: Mon, 18 Jun 2007 09:25:48 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Carlo Wood <carlo@alinoe.com>, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org, eric@anholt.net, zhenyu.z.wang@intel.com,
       y-goto@jp.fujitsu.com, torvalds@linux-foundation.org
Subject: Re: 2.6.22-rc5 regression
Message-ID: <20070618002548.GC27460@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Carlo Wood <carlo@alinoe.com>, Dave Jones <davej@redhat.com>,
	linux-kernel@vger.kernel.org, eric@anholt.net,
	zhenyu.z.wang@intel.com, y-goto@jp.fujitsu.com,
	torvalds@linux-foundation.org
References: <20070617182254.GA17595@alinoe.com> <20070617195805.GA6125@alinoe.com> <20070617214905.GA6207@alinoe.com> <20070617231858.GB27460@linux-sh.org> <20070618001049.GB1375@alinoe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618001049.GB1375@alinoe.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 02:10:49AM +0200, Carlo Wood wrote:
> On Mon, Jun 18, 2007 at 08:18:58AM +0900, Paul Mundt wrote:
> > The obvious question of course is whether actually reverting this
> > changeset fixes your problem? I would be very surprised if it did.
> 
> Having a git commit Id, like d09c6b809432668371b5de9102f4f9aa6a7c79cc,
> how can I create a .diff file from that?
> 
$ git show d09c6b809432668371b5de9102f4f9aa6a7c79cc | patch -p1 -R
... build and test ...
$ git show d09c6b809432668371b5de9102f4f9aa6a7c79cc | patch -p1
... back to original (or git checkout-index -f mm/page_alloc.c) ...

if you just want to test that single change.

> I think git bisect made an error... as you can see for yourself
> with the list of tested git Id's that I gave - it didn't test
> both sides of that patch imho. If you tell me how to extract a patch
> then I'll manually unapply it to some failing kernel revisions and
> see if that makes a difference.
> 
Assuming that reverting that patch makes no difference, can you provide
the output of 'git bisect log'?
