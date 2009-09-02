Return-Path: <linux-kernel-owner+w=401wt.eu-S1755875AbZIBFx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbZIBFx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 01:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755866AbZIBFxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 01:53:55 -0400
Received: from gate.crashing.org ([63.228.1.57]:33210 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755831AbZIBFxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 01:53:55 -0400
Subject: Re: [PATCH] Fix fake numa on ppc
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ankita Garg <ankita@in.ibm.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090902053653.GA3806@in.ibm.com>
References: <20090901050316.GA4076@in.ibm.com>
	 <20090901055753.GB5563@balbir.in.ibm.com>
	 <20090901092407.GC4076@in.ibm.com>
	 <20090901142729.GA5022@balbir.in.ibm.com>
	 <20090902053653.GA3806@in.ibm.com>
Content-Type: text/plain
Date: Wed, 02 Sep 2009 15:53:43 +1000
Message-Id: <1251870823.14675.420.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-02 at 11:06 +0530, Ankita Garg wrote:
> > Oh! interesting.. cpuless nodes :) I think we need to fix this in the
> > longer run and distribute cpus between fake numa nodes of a real node
> > using some acceptable heuristic.
> >
> 
> True. Presently this is broken on both x86 and ppc systems. It would be
> interesting to find a way to map, for example, 4 cpus to >4 number of
> fake nodes created from a single real numa node!

Since I'm pretty sure there could be CPU less nodes just like there
could be memory-less nodes, it would be good if fake numa could
simulate them too :-)

Cheers,
Ben.


