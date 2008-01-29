Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbYA2VO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbYA2VO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 16:14:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbYA2VOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 16:14:19 -0500
Received: from sinclair.provo.novell.com ([137.65.248.137]:36014 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbYA2VOS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 16:14:18 -0500
Message-Id: <479F4F5E.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 29 Jan 2008 14:07:58 -0700
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Paul Jackson" <pj@sgi.com>
Cc: <a.p.zijlstra@chello.nl>, <mingo@elte.hu>, <dmitry.adamushko@gmail.com>,
       <rostedt@goodmis.org>, <menage@google.com>, <rientjes@google.com>,
       <tong.n.li@intel.com>, <tglx@linutronix.de>,
       <akpm@linux-foundation.org>, <dhaval@linux.vnet.ibm.com>,
       <vatsa@linux.vnet.ibm.com>, <sgrubb@redhat.com>,
       <linux-kernel@vger.kernel.org>, <ebiederm@xmission.com>,
       <nickpiggin@yahoo.com.au>
Subject: Re: scheduler scalability - cgroups, cpusets and
	load-balancing
References: <1201600428.28547.87.camel@lappy>
 <1201604243.28547.101.camel@lappy> <20080129053005.bc7a11d7.pj@sgi.com>
 <1201607401.28547.124.camel@lappy> <479F0507.BA47.005A.0@novell.com>
 <20080129105104.d70f36ef.pj@sgi.com> <479F1A4F.BA47.005A.0@novell.com>
 <20080129130403.92d0a1fe.pj@sgi.com> <479F4812.BA47.005A.0@novell.com>
 <20080129150234.b57ce988.pj@sgi.com>
In-Reply-To: <20080129150234.b57ce988.pj@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Tue, Jan 29, 2008 at  4:02 PM, in message
<20080129150234.b57ce988.pj@sgi.com>, Paul Jackson <pj@sgi.com> wrote: 
> Gregory wrote:
>> > ... (1) turning off
>> > sched_load_balance in any overlapping cpusets, including all
>> > encompassing parent cpusets, (2) leaving sched_load_balance on in the
>> > RT cpuset itself, and ...
>>
>> Technically you only need (2).  I run my 4-8 core development systems
>> in the single default global cpuset, normally.
> 
> Well, if you're running in the default cpuset, then you automatically get 
> (1),
> because sched_load_balance is turned off in all overlapping cpusets (there
> aren't any overlapping cpusets!)
> 
> So, yes, you -do- need both (1) and (2).  In your normal system, you
> just happen to get (1) effortlessly.


Ah.  Well see, I am just showing my ignorance of this area of the cpuset code then.  I stand corrected, and sorry for the noise. :)

-Greg

