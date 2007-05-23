Return-Path: <linux-kernel-owner+w=401wt.eu-S934495AbXEWPH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934495AbXEWPH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 11:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756509AbXEWPHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 11:07:49 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:15466 "EHLO
	viefep34-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755863AbXEWPHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 11:07:49 -0400
Subject: Re: [PATCH 3/7] lockdep: lock contention tracking
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <Pine.LNX.4.64.0705231035270.22023@dhcp83-20.boston.redhat.com>
References: <20070523072618.129001605@chello.nl>
	 <20070523095807.407148940@chello.nl>
	 <Pine.LNX.4.64.0705231035270.22023@dhcp83-20.boston.redhat.com>
Content-Type: text/plain
Date: Wed, 23 May 2007 17:07:45 +0200
Message-Id: <1179932865.7019.90.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-23 at 10:40 -0400, Jason Baron wrote:
> On Wed, 23 May 2007, Peter Zijlstra wrote:
> 
> > Count lock contention events per lock class. Additionally track the first four
> > callsites that resulted in the contention.
> > 
> 
> I think that we need the total number of locking calls, not just the total 
> number of *contended* locking calls, in order to make the data 
> significant. Same for waittime. Yes, this pollutes the fastpath. In the 
> contention case, its one extra addition, and for the waittime, its a call 
> the sched_clock(). I don't think that's too much to pay for much more 
> meaningful data.

The holdtime statistics add these numbers.

