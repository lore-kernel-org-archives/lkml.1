Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbZAZUnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbZAZUnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 15:43:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbZAZUnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 15:43:37 -0500
Received: from relay2.sgi.com ([192.48.179.30]:57783 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750988AbZAZUng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 15:43:36 -0500
Message-ID: <497E2075.7040003@sgi.com>
Date: Mon, 26 Jan 2009 12:43:33 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, rusty@rustcorp.com.au,
       mingo@redhat.com, davej@redhat.com, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
References: <20090116191108.135927000@polaris-admin.engr.sgi.com> <20090116191108.533053000@polaris-admin.engr.sgi.com> <20090124001537.7cfde78e.akpm@linux-foundation.org> <200901261711.43943.rusty@rustcorp.com.au> <20090125230130.bcdab2e5.akpm@linux-foundation.org> <20090126171618.GA32091@elte.hu> <20090126103529.cb124a58.akpm@linux-foundation.org> <20090126202022.GA8867@elte.hu>
In-Reply-To: <20090126202022.GA8867@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...
>> We have one single (known) caller in the whole kernel.  This is not 
>> worth adding another great pile of kernel threads for!
> 
> i'd expect there to be more as part of the cpumask stack reduction 
> patches that Rusty and Mike are working on.

There are currently 10 instances queued up in tip/cpus4096 along with
another four "FIXME:  use work_on_cpu()"  comments.

