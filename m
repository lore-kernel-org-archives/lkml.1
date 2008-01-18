Return-Path: <linux-kernel-owner+w=401wt.eu-S1763864AbYARXVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763864AbYARXVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 18:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbYARXVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 18:21:07 -0500
Received: from mga07.intel.com ([143.182.124.22]:64447 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751933AbYARXVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 18:21:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,218,1199692800"; 
   d="scan'208";a="368980721"
Message-ID: <47913435.4010004@linux.intel.com>
Date: Fri, 18 Jan 2008 15:20:21 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: "Frank Ch. Eigler" <fche@redhat.com>
CC: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2/3] Latencytop instrumentations part 1
References: <4790E3A6.7060807@linux.intel.com> <20080118094048.10e79ff9@laptopd505.fenrus.org> <y0mmyr2ydmm.fsf@ton.toronto.redhat.com> <20080118143334.28ba08ca@laptopd505.fenrus.org> <20080118231109.GC27193@redhat.com>
In-Reply-To: <20080118231109.GC27193@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frank Ch. Eigler wrote:
> Hi -
> 
> On Fri, Jan 18, 2008 at 02:33:34PM -0800, Arjan van de Ven wrote:
>> [...]
>>> Can you suggest of some reason why all this instrumentation could
>>> not be in the form of standard markers (perhaps conditionally
>>> compiled out if necessary)?
>> sure. Every instrumentation you see is of the nested kind (since the lowest level
>> of nesting is already automatic via wchan).
>> If markers can provide me the following semantics, I'd be MORE than happy to use markers:
>> [...]
>> If markers can provide that semantics ... you sold me.
> 
> Further to what acme said, markers are semantics-free.  Callback
> functions that implement your entry & exit semantics can be attached
> at run time, at your pleasure.  (So can systemtap probes, for that
> matter.)  The main difference would be that these callback functions
> would have manage the per-thread LIFO data structures themselves,
> instead of allocating backpointers on the kernel stack.  (Bonus marks
> for not modifying task_struct. :-)

modifying task struct to have storage space is no big deal...
