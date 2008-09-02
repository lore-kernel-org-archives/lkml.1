Return-Path: <linux-kernel-owner+w=401wt.eu-S1753150AbYIBSLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbYIBSLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 14:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751113AbYIBSLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 14:11:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbYIBSLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 14:11:03 -0400
Date: Tue, 2 Sep 2008 14:06:20 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, Paul Menage <menage@google.com>,
       randy.dunlap@oracle.com, Carl Henrik Lunde <chlunde@ping.uio.no>,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, akpm@linux-foundation.org, agk@sourceware.org,
       subrata@linux.vnet.ibm.com, axboe@kernel.dk,
       Marco Innocenti <m.innocenti@cineca.it>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, matt@bluehost.com, roberto@unbit.it,
       ngupta@google.com
Subject: Re: [RFC][PATCH -mm 0/5] cgroup: block device i/o controller (v9)
Message-ID: <20080902180620.GE15847@redhat.com>
References: <1219853257-11052-1-git-send-email-righi.andrea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219853257-11052-1-git-send-email-righi.andrea@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 06:07:32PM +0200, Andrea Righi wrote:
> 
> The objective of the i/o controller is to improve i/o performance
> predictability of different cgroups sharing the same block devices.
> 
> Respect to other priority/weight-based solutions the approach used by this
> controller is to explicitly choke applications' requests that directly (or
> indirectly) generate i/o activity in the system.
> 

Hi Andrea,

I was checking out the pass discussion on this topic and there seemed to
be two kind of people. One who wanted to control max bandwidth and other
who liked proportional bandwidth approach  (dm-ioband folks).

I was just wondering, is it possible to have both the approaches and let
users decide at run time which one do they want to use (something like
the way users can choose io schedulers).

Thanks
Vivek
