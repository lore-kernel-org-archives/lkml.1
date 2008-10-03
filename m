Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbYJCPFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbYJCPFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 11:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbYJCPFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 11:05:37 -0400
Received: from mga12.intel.com ([143.182.124.36]:61140 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752075AbYJCPFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 11:05:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,356,1220252400"; 
   d="scan'208";a="54646543"
Message-ID: <48E634B7.60002@linux.intel.com>
Date: Fri, 03 Oct 2008 08:05:27 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: Jan Kasprzak <kas@fi.muni.cz>, linux-kernel@vger.kernel.org
Subject: Re: IRQ balancing on a router
References: <20081003132117.GM16624@fi.muni.cz> <20081003063857.76b7b61a@linux.intel.com> <20081003142941.GC3167@redhat.com>
In-Reply-To: <20081003142941.GC3167@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Baron wrote:
>> one of the hard cases for irqbalance is that irqbalance doesn't have a
>> way to find out the actual cpu time spend in the handlers. For
>> networking it makes an estimate just based on the number of packets
>> (which is better than nothing)... but that breaks down if you have an
>> non-symmetry in CPU costs per packet like you have.
>>
>> The good news is that irqthreads at least have the potential to solve
>> this "lack of information"; if not, we could consider doing a form of
>> microaccounting for irq handlers....
>>
>>
> 
> perhaps, this could be addressed using tracepoints. The currently
> proposed ones are at the beginning and end of 'handle_IRQ_event()'. See:
> http://marc.info/?l=linux-kernel&m=121616099830280&w=2
> 
something that you always need should not be a tracepoint.

