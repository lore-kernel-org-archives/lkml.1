Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572AbYA2Kv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbYA2Kv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 05:51:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbYA2KvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 05:51:19 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40661 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403AbYA2KvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 05:51:18 -0500
Subject: Re: scheduler scalability - cgroups, cpusets and load-balancing
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Jackson <pj@sgi.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, vatsa@linux.vnet.ibm.com,
       dhaval@linux.vnet.ibm.com, nickpiggin@yahoo.com.au,
       ebiederm@xmission.com, akpm@linux-foundation.org, sgrubb@redhat.com,
       rostedt@goodmis.org, ghaskins@novell.com, dmitry.adamushko@gmail.com,
       tong.n.li@intel.com, tglx@linutronix.de, menage@google.com,
       rientjes@google.com
In-Reply-To: <20080129040130.7b2904b6.pj@sgi.com>
References: <1201600428.28547.87.camel@lappy>
	 <20080129040130.7b2904b6.pj@sgi.com>
Content-Type: text/plain
Date: Tue, 29 Jan 2008 11:50:16 +0100
Message-Id: <1201603816.28547.94.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-29 at 04:01 -0600, Paul Jackson wrote:
> Peter wrote:
> > Also the RT load-balance needs to become aware of such these sets, I
> > think Paul J and Steven once talked about it, but can't quite remember
> > where that ended
> 
> See further the thread:
> 
>   http://lkml.org/lkml/2007/10/22/400
> 
> (I don't remember where it ended up either; probably nowhere.
>  I'm just passing on the link, before doing any reading or thinking.)

Thanks for the link. Yes I think your last suggestion of creating
rt-domains ( http://lkml.org/lkml/2007/10/23/419 ) is a good one.

Upon cpuset changes we could then look for the largest disjoint set and
hang the rt balance code from that.


