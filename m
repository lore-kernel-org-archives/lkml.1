Return-Path: <linux-kernel-owner+w=401wt.eu-S1756303AbZGHNma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303AbZGHNma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 09:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755544AbZGHNmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 09:42:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45492 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755577AbZGHNmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 09:42:22 -0400
Date: Wed, 8 Jul 2009 09:41:14 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, jbaron@redhat.com, agk@redhat.com,
       snitzer@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
Subject: Re: [RFC] IO scheduler based IO controller V6
Message-ID: <20090708134114.GA24048@redhat.com>
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com> <20090708035621.GB3215@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090708035621.GB3215@balbir.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 09:26:21AM +0530, Balbir Singh wrote:
> * Vivek Goyal <vgoyal@redhat.com> [2009-07-02 16:01:32]:
> 
> > 
> > Hi All,
> > 
> > Here is the V6 of the IO controller patches generated on top of 2.6.31-rc1.
> > 
> > Previous versions of the patches was posted here.
> > 
> > (V1) http://lkml.org/lkml/2009/3/11/486
> > (V2) http://lkml.org/lkml/2009/5/5/275
> > (V3) http://lkml.org/lkml/2009/5/26/472
> > (V4) http://lkml.org/lkml/2009/6/8/580
> > (V5) http://lkml.org/lkml/2009/6/19/279
> > 
> > This patchset is still work in progress but I want to keep on getting the
> > snapshot of my tree out at regular intervals to get the feedback hence V6.
> >
> 
> Hi, Vivek,
> 
> I was able to compile and boot a 2.6.31-rc1 kernel with this patchset.
> I have a request could you fold up all patches and make one
> consolidated patch available somewhere (makes it easier to test), may
> be a git tree?
> 

Thanks for trying it out balbir. Ok, for ease of patching and testing, I 
will also maintain a consolidated patch. For V6 you can download the patch
from here.

http://people.redhat.com/~vgoyal/io-controller/io-scheduler-based-io-controller-v6.patch

> I did some quick tests with some io benchmarks and found in a simple
> scenario that the scheduler worked as expected, except that it took
> very long. I'll investigate further and revert back.

Thanks. I will wait for details.

Vivek
