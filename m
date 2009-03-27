Return-Path: <linux-kernel-owner+w=401wt.eu-S1759290AbZC0QYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290AbZC0QYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 12:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757811AbZC0QX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 12:23:56 -0400
Received: from viefep18-int.chello.at ([62.179.121.38]:9749 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757665AbZC0QX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 12:23:56 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH] sched: rt group scheduling, compare child's limit
 against parent's
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Gautham Shenoy <ego@in.ibm.com>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20090327161915.GA8891@linux.vnet.ibm.com>
References: <20090327161915.GA8891@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Fri, 27 Mar 2009 17:23:59 +0100
Message-Id: <1238171039.16890.308.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-27 at 21:49 +0530, Dhaval Giani wrote:
> Hi Ingo, Peter,
> 
> I've not been able to follow the reasoning behind checking the sum of
> the children's runtime not exceeding the parent's runtime as opposed to
> the child's runtime not exceeding that of the parent.
> 
> From what I understand, the limits only guarantee that the group cannot
> exceed a certain limit and not guarantee a group gets to run. If my
> understanding is corrct, maybe the following patch is needed?

NAK, rt needs that as it guarantees a min too.

