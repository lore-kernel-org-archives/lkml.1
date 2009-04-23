Return-Path: <linux-kernel-owner+w=401wt.eu-S1752455AbZDWFLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbZDWFLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 01:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbZDWFLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 01:11:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46094 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751146AbZDWFLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 01:11:35 -0400
Date: Wed, 22 Apr 2009 21:58:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Theodore Tso <tytso@mit.edu>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Righi <righi.andrea@gmail.com>, randy.dunlap@oracle.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>,
       Jens Axboe <jens.axboe@oracle.com>, eric.rannaud@gmail.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>, fernando@oss.ntt.co.jp,
       dradford@bluehost.com, Gui@smtp1.linux-foundation.org,
       agk@sourceware.org, subrata@linux.vnet.ibm.com,
       Paul Menage <menage@google.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com,
       matt@bluehost.com, roberto@unbit.it, ngupta@google.com
Subject: Re: [PATCH 9/9] ext3: do not throttle metadata and journal IO
Message-Id: <20090422215825.f83e1b27.akpm@linux-foundation.org>
In-Reply-To: <20090423043547.GB2723@mit.edu>
References: <20090421174620.GD15541@mit.edu>
	<20090421181429.GO19637@balbir.in.ibm.com>
	<20090421191401.GF15541@mit.edu>
	<20090421204905.GA5573@linux>
	<20090422093349.1ee9ae82.kamezawa.hiroyu@jp.fujitsu.com>
	<20090422102153.9aec17b9.kamezawa.hiroyu@jp.fujitsu.com>
	<20090422102239.GA1935@linux>
	<20090423090535.ec419269.kamezawa.hiroyu@jp.fujitsu.com>
	<20090423012254.GZ15541@mit.edu>
	<20090423115419.c493266a.kamezawa.hiroyu@jp.fujitsu.com>
	<20090423043547.GB2723@mit.edu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Apr 2009 00:35:48 -0400 Theodore Tso <tytso@mit.edu> wrote:

> I hope someone like akpm is paying very close attention and auditing
> these patches both from an low-level patch cleanliness point of view
> as well as a high-level design review.

Not yet, really.  But I intend to.  Largely because I've always been
very skeptical that anyone has found a good solution to...

>  Or at least that *someone* is
> doing so and can perhaps document how all of these knobs interact.
> After all, if they are going to be separate, and someone turns the I/O
> throttling knob without bothering to turn the write throttling knob
> --- what's going to happen?  An OOM?  That's not going to be very safe
> or friendly for the sysadmin who plans to be configuring the system.

... this problem.
