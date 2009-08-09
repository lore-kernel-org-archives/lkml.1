Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237AbZHIXB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbZHIXB2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 19:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbZHIXB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 19:01:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:64040 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbZHIXB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 19:01:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,349,1246863600"; 
   d="scan'208";a="539875643"
Message-ID: <4A7F554A.8080402@linux.intel.com>
Date: Sun, 09 Aug 2009 16:01:30 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: perf: store and retrieve trace event names in the perf.data	file
References: <4A7F4463.3050508@linux.intel.com> <20090809224400.GA6089@nowhere>
In-Reply-To: <20090809224400.GA6089@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Sun, Aug 09, 2009 at 02:49:23PM -0700, Arjan van de Ven wrote:
>> In order to be able to use trace events, a key aspect is the "type" field;
>> this is the id of the event that you recorded, as stored in the /sys/kernel/debug/events/*/*/id file.
>> What is currently missing is a way to map the id number (which is not abi stable)
>> to the event that was recorded.
> 
> 
> 
> We already have that.
> See tools/perf/util/parse-events.c: char *tracepoint_id_to_name(u64 id)


sadly... we don't.

You do it *on the same boot and machine* as you created the perf.data file.
You don't have it when you reboot into a new kernel, or move the perf.data file
to a new machine........

Which is to be honest a very common usecase.

