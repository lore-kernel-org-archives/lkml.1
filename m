Return-Path: <linux-kernel-owner+w=401wt.eu-S1758431AbZGHD4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758431AbZGHD4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 23:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755954AbZGHD41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 23:56:27 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:46977 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755868AbZGHD40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 23:56:26 -0400
Date: Wed, 8 Jul 2009 09:26:21 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
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
Message-ID: <20090708035621.GB3215@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1246564917-19603-1-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vivek Goyal <vgoyal@redhat.com> [2009-07-02 16:01:32]:

> 
> Hi All,
> 
> Here is the V6 of the IO controller patches generated on top of 2.6.31-rc1.
> 
> Previous versions of the patches was posted here.
> 
> (V1) http://lkml.org/lkml/2009/3/11/486
> (V2) http://lkml.org/lkml/2009/5/5/275
> (V3) http://lkml.org/lkml/2009/5/26/472
> (V4) http://lkml.org/lkml/2009/6/8/580
> (V5) http://lkml.org/lkml/2009/6/19/279
> 
> This patchset is still work in progress but I want to keep on getting the
> snapshot of my tree out at regular intervals to get the feedback hence V6.
>

Hi, Vivek,

I was able to compile and boot a 2.6.31-rc1 kernel with this patchset.
I have a request could you fold up all patches and make one
consolidated patch available somewhere (makes it easier to test), may
be a git tree?

I did some quick tests with some io benchmarks and found in a simple
scenario that the scheduler worked as expected, except that it took
very long. I'll investigate further and revert back.
 
-- 
	Balbir
