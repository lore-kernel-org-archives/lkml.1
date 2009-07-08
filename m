Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090AbZGHOkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbZGHOkH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 10:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756569AbZGHOjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 10:39:44 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:48043 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755613AbZGHOjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 10:39:41 -0400
Date: Wed, 8 Jul 2009 20:09:25 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: dhaval@linux.vnet.ibm.com, snitzer@redhat.com, dm-devel@redhat.com,
       jens.axboe@oracle.com, agk@redhat.com, paolo.valente@unimore.it,
       fernando@oss.ntt.co.jp, jmoyer@redhat.com, fchecconi@gmail.com,
       akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, righi.andrea@gmail.com
Subject: Re: [RFC] IO scheduler based IO controller V6
Message-ID: <20090708143925.GE3215@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com> <20090708035621.GB3215@balbir.in.ibm.com> <20090708134114.GA24048@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090708134114.GA24048@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vivek Goyal <vgoyal@redhat.com> [2009-07-08 09:41:14]:

> On Wed, Jul 08, 2009 at 09:26:21AM +0530, Balbir Singh wrote:
> > * Vivek Goyal <vgoyal@redhat.com> [2009-07-02 16:01:32]:
> > 
> > > 
> > > Hi All,
> > > 
> > > Here is the V6 of the IO controller patches generated on top of 2.6.31-rc1.
> > > 
> > > Previous versions of the patches was posted here.
> > > 
> > > (V1) http://lkml.org/lkml/2009/3/11/486
> > > (V2) http://lkml.org/lkml/2009/5/5/275
> > > (V3) http://lkml.org/lkml/2009/5/26/472
> > > (V4) http://lkml.org/lkml/2009/6/8/580
> > > (V5) http://lkml.org/lkml/2009/6/19/279
> > > 
> > > This patchset is still work in progress but I want to keep on getting the
> > > snapshot of my tree out at regular intervals to get the feedback hence V6.
> > >
> > 
> > Hi, Vivek,
> > 
> > I was able to compile and boot a 2.6.31-rc1 kernel with this patchset.
> > I have a request could you fold up all patches and make one
> > consolidated patch available somewhere (makes it easier to test), may
> > be a git tree?
> > 
> 
> Thanks for trying it out balbir. Ok, for ease of patching and testing, I 
> will also maintain a consolidated patch. For V6 you can download the patch
> from here.
> 
> http://people.redhat.com/~vgoyal/io-controller/io-scheduler-based-io-controller-v6.patch
>

Thanks, this will definitely help me get more testing done!
 
> > I did some quick tests with some io benchmarks and found in a simple
> > scenario that the scheduler worked as expected, except that it took
> > very long. I'll investigate further and revert back.
> 
> Thanks. I will wait for details.
>

I'll try and send something out by Friday, but for now I am not even
very sure if it is a real problem. I ran iozone on two groups with 500
and 1000 as weights on the same parition and set fairness to 1 in
sysfs for the partition. I used a record size of 4 (default) and tried
to run it on a file size of 1G.

BTW, I don't see anything about weights being multiple of an expected
figure documented anywhere. I tried weights of 1024 (similar to the
scheduler and got shouted back at :) ). Does the documentation patch
specify the expected range for weights? 

-- 
	Balbir
