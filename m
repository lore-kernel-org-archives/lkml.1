Return-Path: <linux-kernel-owner+w=401wt.eu-S1757827AbZIQMVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827AbZIQMVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 08:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755020AbZIQMVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 08:21:40 -0400
Received: from mtagate7.de.ibm.com ([195.212.17.167]:44531 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbZIQMVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 08:21:40 -0400
Date: Thu, 17 Sep 2009 14:21:41 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, cl@linux-foundation.org, mingo@elte.hu,
       npiggin@suse.de, sachinp@in.ibm.com
Subject: Re: [RFC/PATCH] SLQB: Mark the allocator as broken PowerPC and S390
Message-ID: <20090917122141.GB5041@osiris.boeblingen.de.ibm.com>
References: <1253083059.5478.1.camel@penberg-laptop>
 <20090917100841.GF13002@csn.ul.ie>
 <1253183365.4975.20.camel@penberg-laptop>
 <20090917105707.GA7205@csn.ul.ie>
 <20090917121232.GA5041@osiris.boeblingen.de.ibm.com>
 <1253189782.4975.51.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253189782.4975.51.camel@penberg-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 03:16:21PM +0300, Pekka Enberg wrote:
> On Thu, 2009-09-17 at 14:12 +0200, Heiko Carstens wrote:
> > Ok, I just wanted to debug this on s390. But... the bug seems to have
> > disappeared.
> > I pulled in
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git slqb/core
> > 
> > and tried defconfig (+SLQB) as well as allyesconfig (+SLQB). Both started and
> > didn't show the crash-before-console-is-active which went away when switching
> > to a different allocator.
> > So the s390 restriction seems to be resolved. Don't know why...
> 
> IIRC, this is the only bug fix that was merged after your report:
> 
> http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commitdiff;h=ff61c4950125b09b5e5a83d48a6c81827e9d67ab

Still works even if I revert that patch. Probably something else interfered.
