Return-Path: <linux-kernel-owner+w=401wt.eu-S1762009AbXK2QTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762009AbXK2QTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 11:19:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756785AbXK2QTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 11:19:39 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:46170 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755644AbXK2QTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 11:19:38 -0500
Message-ID: <474EE667.6050106@linux.vnet.ibm.com>
Date: Thu, 29 Nov 2007 21:48:47 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Linux Memory Management List <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hugh Dickins <hugh@veritas.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Pavel Emelianov <xemul@sw.ru>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Christoph Lameter <clameter@sgi.com>,
       "Martin J. Bligh" <mbligh@google.com>,
       Andy Whitcroft <andyw@uk.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: What can we do to get ready for memory controller merge in 2.6.25
References: <474ED005.7060300@linux.vnet.ibm.com> <20071129104726.5698321f@cuia.boston.redhat.com>
In-Reply-To: <20071129104726.5698321f@cuia.boston.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> On Thu, 29 Nov 2007 20:13:17 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> They say better strike when the iron is hot.
>>
>> Since we have so many people discussing the memory controller, I would
>> like to access the readiness of the memory controller for mainline
>> merge.
> 
>> At the VM-Summit we decided to try the current double LRU approach for
>> memory control. At this juncture in the space-time continuum, I seek
>> your support, feedback, comments and help to move the memory controller
> 
> The memory controller code currently in -mm seems fine to me,
> especially with the changes that got committed over the last
> days making reclaim more efficient.
> 

Yes, I agree. Per zone reclaim and lists have helped make the code
better. Credit goes to KAMEZAWA-San for the per zone code and to
YAMAMOTO-San for background reclaim.

> I don't think there are any bugs left that can be found by
> code inspection - only the kind of testing that the mainline
> kernel gets might shake out more bugs.
> 
> I would like to see the memory controller code go into the
> mainline kernel ASAP.
> 

Excellent, thanks!


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
