Return-Path: <linux-kernel-owner+w=401wt.eu-S1754284AbYJaFKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbYJaFKx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 01:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbYJaFKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 01:10:33 -0400
Received: from gw.goop.org ([64.81.55.164]:47210 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464AbYJaFKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 01:10:32 -0400
Message-ID: <490A9337.6090504@goop.org>
Date: Fri, 31 Oct 2008 16:10:15 +1100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Ingo Molnar <mingo@elte.hu>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>
Subject: Re: [patch] generic-ipi: fix the smp_mb() placement
References: <20081029224229.GK30573@linux-os.sc.intel.com> <20081030185322.GE17822@elte.hu> <20081030202322.GM30573@linux-os.sc.intel.com>
In-Reply-To: <20081030202322.GM30573@linux-os.sc.intel.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> We didn't see the lockup in our tests but Xen folks reported similar failures
> with their smp call function code.
>   

...really?  I don't remember anything like that, but perhaps I'm 
forgetting something.  In Xen the IPI is sent with a hypercall, which is 
definitely a solid enough barrier for these purposes.

    J
