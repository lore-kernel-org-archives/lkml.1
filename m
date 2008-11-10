Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbYKJO4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbYKJO4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 09:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbYKJO4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 09:56:01 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109AbYKJO4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 09:56:00 -0500
Date: Mon, 10 Nov 2008 09:55:55 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Christoph Hellwig <hch@infradead.org>,
       Chandra Seetharaman <sekharan@us.ibm.com>,
       Alasdair G Kergon <agk@redhat.com>, dm-devel <dm-devel@redhat.com>,
       linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: Queue upcall locking (was: [dm-devel] [RFC][PATCH] fix
 dm_any_congested() to properly sync up with suspend code path)
In-Reply-To: <1226328417.7685.198.camel@twins>
Message-ID: <Pine.LNX.4.64.0811100952150.19937@hs20-bc2-1.build.redhat.com>
References: <1225944008.14830.1101.camel@chandra-ubuntu> 
 <Pine.LNX.4.64.0811100746180.24696@hs20-bc2-1.build.redhat.com> 
 <20081110135401.GA11606@infradead.org>  <Pine.LNX.4.64.0811100914500.14825@hs20-bc2-1.build.redhat.com>
  <1226327210.7685.173.camel@twins>  <Pine.LNX.4.64.0811100929380.16965@hs20-bc2-1.build.redhat.com>
 <1226328417.7685.198.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2008, Peter Zijlstra wrote:

> > If you have a physical disk that has many LVM volumes on it, you end up in 
> > a situation when disk congestion state change is reported to all the 
> > volumes. So it will create O(n) problem at the other side.
> 
> *sigh* I can almost understand why people want to use lvm to combine
> multiple disks, but why make the partition thing even worse...

To protect the services from each other --- so that mail storm won't blow 
user's directories, users blowing their space can't corrupt the system 
updates, logs are kept safely even if other partition overflows etc.

I just know some admins who prefer to have separate filesystems instead of 
quotas for this purpose.

Mikulas
