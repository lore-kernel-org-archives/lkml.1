Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbXD0Gpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbXD0Gpu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 02:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755420AbXD0Gpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 02:45:50 -0400
Received: from gw.goop.org ([64.81.55.164]:47627 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755419AbXD0Gpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 02:45:49 -0400
Message-ID: <46319C3B.2010300@goop.org>
Date: Thu, 26 Apr 2007 23:46:19 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Benjamin LaHaise <bcrl@kvack.org>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 11/25] xen: Xen SMP guest support
References: <20070423215638.563901986@goop.org> <20070423215711.197402369@goop.org> <200704251124.48445.ak@suse.de>
In-Reply-To: <200704251124.48445.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> +/* VCPUs are single-cored, and have no siblings */
>> +static void set_cpu_sibling_map(int cpu)
>>     
>
> Can you put this somewhere generic and use it everywhere? Don't want
> duplication of this code.
>   

Are there any other users?  This is a very cutdown version of the code
in kernel/smpboot.c; under Xen all CPUs are considered to be
single-cored and single-threaded, so there's not a lot to do here.

    J
