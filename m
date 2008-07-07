Return-Path: <linux-kernel-owner+w=401wt.eu-S1757760AbYGGXEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760AbYGGXEK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 19:04:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbYGGXD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 19:03:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:55452 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754177AbYGGXD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 19:03:56 -0400
Subject: Re: [Ksummit-2008-discuss] Delayed interrupt work, thread pools
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Chris Mason <chris.mason@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Jeremy Kerr <jk@ozlabs.org>
In-Reply-To: <1215439756.24425.21.camel@think.oraclecorp.com>
References: <1214916335.20711.141.camel@pasglop>
	 <486B0298.5030508@linux.intel.com> <1214977447.21182.33.camel@pasglop>
	 <1215007896.3330.6.camel@localhost.localdomain>
	 <1215439756.24425.21.camel@think.oraclecorp.com>
Content-Type: text/plain
Date: Tue, 08 Jul 2008 09:03:02 +1000
Message-Id: <1215471782.8970.165.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-07 at 10:09 -0400, Chris Mason wrote:
> I have a few different users of the thread pools, and I ended up
> having
> to create a number of pools to avoid deadlocks between different types
> of operations on the same work list.  Ideas like the next activation
> head really sound cool, but the simplicity of just making dedicated
> pools to dedicated tasks is much much easier to debug.
> 
> If the pools are able to resize themselves sanely, it should perform
> about the same as the fancy stuff ;)

Could be just like workqueues: a "default" common pool and the ability
to create specialized pools with possibly configurable constraints in
size etc...

I'm a bit too busy with preparing for the merge window right now along
with a few other things, so I haven't looked in details at the existing
implementations yet. I'm in no hurry tho, thus somebody feel free to
beat me to it, else I'll dig into it later this month or so.

Ben.

