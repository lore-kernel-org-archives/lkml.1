Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab0BATjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 14:39:53 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:51917 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904Ab0BATjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 14:39:51 -0500
Message-ID: <4B672DEE.8000804@linux.vnet.ibm.com>
Date: Mon, 01 Feb 2010 11:39:26 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Dan Terpstra <terpstra@eecs.utk.edu>, Philip Mucci <mucci@eecs.utk.edu>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [RFC] perf_events: support for uncore a.k.a. nest units
References: <4B560ACD.4040206@linux.vnet.ibm.com> <1263994448.4283.1052.camel@laptop> <1264023204.4283.1124.camel@laptop> <4B57907E.5000207@linux.vnet.ibm.com> <20100121072118.GA10585@elte.hu> <4B58A750.2060607@linux.vnet.ibm.com> <4B58AAF7.60507@linux.vnet.ibm.com> <20100127102834.GA27357@elte.hu>  <4B60990C.1030804@linux.vnet.ibm.com> <1264676244.4283.2093.camel@laptop>  <4B61D0CB.4090809@linux.vnet.ibm.com> <1264705607.4283.2120.camel@laptop>  <4B620AD4.8000108@linux.vnet.ibm.com> <1264758747.4283.2150.camel@laptop>  <4B6369B2.1060508@linux.vnet.ibm.com> <1264840979.24455.51.camel@laptop>
In-Reply-To: <1264840979.24455.51.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 1/30/2010 12:42 AM, Peter Zijlstra wrote:
> On Fri, 2010-01-29 at 15:05 -0800, Corey Ashford wrote:
>> So you'd read the id from the sysfs topology tree, and then pass that id to the
>> interface?  That's an interesting approach that eliminates the need to pass a
>> string pmu path to the kernel.
>
> No, the attr.pmu_id would reflect the location in the tree (pci
> location, or spu number), the pmu id reported would identify the kind of
> pmu driver used for that particular device.
>
> I realized this confusion after sending but didn't clarify, we should
> come up with a good alternative name for either (or both) uses.
>

Ok, just so I'm clear here, is attr.pmu_id a (char *) or some sort of encoded 
bit field?

- Corey

