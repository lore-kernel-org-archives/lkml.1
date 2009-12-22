Return-Path: <linux-kernel-owner+w=401wt.eu-S1752238AbZLVLFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbZLVLFk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 06:05:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbZLVLFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 06:05:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:55284 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbZLVLFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 06:05:39 -0500
Subject: Re: workqueue thing
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
In-Reply-To: <4B3009DC.7020407@kernel.org>
References: <1261141088-2014-1-git-send-email-tj@kernel.org>
	 <1261143924.20899.169.camel@laptop>  <4B2EE5A5.2030208@kernel.org>
	 <1261387377.4314.37.camel@laptop>  <4B2F7879.2080901@kernel.org>
	 <1261405604.4314.154.camel@laptop>  <4B3009DC.7020407@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Dec 2009 12:04:17 +0100
Message-ID: <1261479857.4937.18.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-22 at 08:50 +0900, Tejun Heo wrote:
> > Also, I think that whole move tasks back on online stuff is utter crazy,
> > just move then to another cpu and leave them there.
> 
> Can you be more specific?  Why is it crazy when moving to online but
> !active cpu is necessary anyway? 

because its extra (and above all ugly code) that serves no purpose what
so ever.

