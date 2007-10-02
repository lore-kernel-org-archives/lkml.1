Return-Path: <linux-kernel-owner+w=401wt.eu-S1755686AbXJBSSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbXJBSSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 14:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbXJBSSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 14:18:40 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48374 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752478AbXJBSSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 14:18:40 -0400
Date: Tue, 2 Oct 2007 11:18:39 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       mpm@selenic.com, "Huang, Ying" <ying.huang@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, apw@shadowen.org,
       "Lee.Schermerhorn@hp.com" <Lee.Schermerhorn@hp.com>
Subject: Re: x86 patches was Re: -mm merge plans for 2.6.24
In-Reply-To: <20071002171631.46888326.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0710021116560.30615@schroedinger.engr.sgi.com>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
 <p733awu6nva.fsf@bingen.suse.de> <20071001233225.88c67e8b.akpm@linux-foundation.org>
 <20071002070110.GA30490@one.firstfloor.org> <20071002001809.0a814d0b.akpm@linux-foundation.org>
 <20071002163624.74534e7f.kamezawa.hiroyu@jp.fujitsu.com>
 <20071002004324.be030b63.akpm@linux-foundation.org>
 <20071002171631.46888326.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2007, KAMEZAWA Hiroyuki wrote:

> For fujitsu, problem is called "empty" node.

Future SGI platforms (actually also current one can have but nothing like 
that is deployed to my knowledge) have nodes with only cpus. Current SGI 
platforms have nodes with just I/O that we so far cannot manage in the 
core. So the arch code maps them to the nearest memory node.
